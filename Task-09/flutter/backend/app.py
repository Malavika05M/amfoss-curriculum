from flask import Flask, request, jsonify, make_response, Response
from flask_cors import CORS, cross_origin
from flask_bcrypt import Bcrypt
import requests
from flask_mysqldb import MySQL
import json
import random

app = Flask(__name__)
CORS(app)
bcrypt = Bcrypt(app)

app.config['MYSQL_HOST'] = '127.0.0.1'
app.config['MYSQL_PORT'] = 3306
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '' 
app.config['MYSQL_DB'] = 'pokedex'

mysql = MySQL(app)

@app.route('/api/register', methods=['POST'])
def register_user():
    data = request.json
    if not all(key in data for key in ['username', 'name', 'password']):
        return jsonify({"success": False, "message": "Missing required fields"}), 400

    username = data['username']
    name = data['name']
    password = data['password']

    try:
        cursor = mysql.connection.cursor()
        
        cursor.execute("SELECT 1 FROM Pokedex WHERE username = %s", (username,))
        if cursor.fetchone():
            return jsonify({"success": False, "message": "Username already exists"}), 409

        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
        starter_pokemon_id = random.randint(1, 151)
        pokemon_list = json.dumps([starter_pokemon_id])

        cursor.execute(
            "INSERT INTO Pokedex (username, name, password, pokelist) VALUES (%s, %s, %s, %s)",
            (username, name, hashed_password, pokemon_list)
        )
        
        mysql.connection.commit()
        return jsonify({
            "success": True,
            "message": "User registered successfully",
            "starterPokemonId": starter_pokemon_id
        }), 201

    except Exception as e:
        print(f"Database error: {e}")
        mysql.connection.rollback()
        return jsonify({"success": False, "message": "Registration failed"}), 500
    finally:
        cursor.close()

@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    if not all(key in data for key in ['username', 'password']):
        return jsonify({"success": False, "message": "Missing required fields"}), 400

    username = data['username']
    password = data['password']

    try:
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM Pokedex WHERE username = %s", (username,))
        user = cursor.fetchone()

        if user and bcrypt.check_password_hash(user['password'], password):
            return jsonify({
                "success": True,
                "username": user['username'],
                "name": user['name']
            }), 200
        else:
            return jsonify({"success": False, "message": "Invalid username or password"}), 401

    except Exception as e:
        print(f"Database error: {e}")
        return jsonify({"success": False, "message": "Login failed"}), 500
    finally:
        cursor.close()



@app.route('/api/pokemon_cards', methods=['GET'])
def home_page():
    url = 'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json'
    try:
        response = requests.get(url)
        pokemon_data = response.json()
        pokemon_data = make_response(jsonify(pokemon_data))
        pokemon_data.headers['Access-Control-Allow-Origin'] = '*'  
        return pokemon_data
    except requests.RequestException as error:
        print(f"Error fetching Pokémon details: {error}")
        return jsonify({"error": "Failed to fetch data from the list"}), 500
    
@app.route("/api/pokemon/<name>", methods=["GET"])
@cross_origin()
def pokemon_details(name):
    url = f'https://pokeapi.co/api/v2/pokemon/{name}/'
    try:
        response = requests.get(url)
        response.raise_for_status()

        pokemon_data = response.json()
        pokemon = {
            "image": pokemon_data["sprites"]["other"]["official-artwork"]["front_default"],
            "name": pokemon_data["name"],
            "types": [t["type"]["name"] for t in pokemon_data["types"]],
            "id": pokemon_data["id"],
            "moves": [move["move"]["name"] for move in pokemon_data["moves"][:5]],
            "stats": pokemon_data["stats"]
        }
        return jsonify(pokemon)
    except requests.RequestException as error:
        print(f"Error fetching Pokémon details: {error}")
        return jsonify({"error": "Failed to fetch data from PokeAPI"}), 500

@app.route("/api/pokelist/add", methods=["POST"])
def add_to_pokelist():
    data = request.json
    if not all(key in data for key in ["username", "pokemonId"]):
        return jsonify({"error": "Missing required fields"}), 400    
    username = data["username"]
    pokemon = str(data["pokemonId"])
    try:
        cursor = mysql.connection.cursor()
        cursor.execute(
            "SELECT pokelist FROM Pokedex WHERE username = %s", 
            (username,)
        )
        existing = cursor.fetchone()
        
        if existing:
            pokelist = existing.get('pokelist')
            if pokelist is None or pokelist == '':
                existing_pokemons = []
            else:
                existing_pokemons = json.loads(pokelist)
                
            if pokemon not in existing_pokemons:
                existing_pokemons.append(pokemon)
                new_pokelist = json.dumps(existing_pokemons)
                cursor.execute(
                    "UPDATE Pokedex SET pokelist = %s WHERE username = %s",
                    (new_pokelist, username)
                )
                mysql.connection.commit()
                return jsonify({"message": "Pokemon added to Pokelist successfully"}), 200
            else:
                return jsonify({"message": "Pokemon already in Pokelist"}), 200
        else:
            return jsonify({"error": "User not found"}), 404
            
    except Exception as e:
        print(f"Database error: {e}")
        mysql.connection.rollback()
        return jsonify({"error": f"Database exception: {str(e)}"}), 500
    finally:
        cursor.close()

@app.route("/api/pokelist/remove", methods=["POST"])
def remove_pokelist():
    data = request.json
    if not all(key in data for key in ["username", "pokemonId"]):
        return jsonify({"error": "Missing required fields"}), 400
    
    username = data["username"]
    pokemonId = str(data["pokemonId"])
    
    try:
        cursor = mysql.connection.cursor()
        cursor.execute(
            "SELECT pokelist FROM Pokedex WHERE username = %s AND JSON_CONTAINS(pokelist, %s)",
            (username, json.dumps(pokemonId))
        )
        if not cursor.fetchone():
            return jsonify({"error": "Pokemon not found for this user"}), 404
        
        cursor.execute(
            "UPDATE Pokedex SET pokelist = JSON_REMOVE(pokelist, JSON_UNQUOTE(JSON_SEARCH(pokelist, 'one', %s)) WHERE username = %s",
            (pokemonId, username)
        )
        
        if cursor.rowcount == 0:
            return jsonify({"error": "Failed to remove Pokémon"}), 400
            
        mysql.connection.commit()
        return jsonify({"message": "Pokemon removed successfully"}), 200
        
    except Exception as e:
        print(f"Error removing Pokémon: {e}")
        mysql.connection.rollback()
        return jsonify({"error": f"Database error: {str(e)}"}), 500
    finally:
        cursor.close()
  
@app.route("/api/pokelist/<username>", methods=["GET"])
def display_pokelist(username):
    try:
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT pokelist FROM Pokedex WHERE username = %s", (username,))
        result = cursor.fetchone()
        
        if result is None:
            return jsonify([]), 200
        else:
            pokelist = json.loads(result['pokelist']) if result['pokelist'] else []
            return jsonify(pokelist), 200
            
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': f'Database error: {str(e)}'}), 500
    finally:
        cursor.close()

@app.route("/trade", methods=["POST"])
def trade_pokemon():
    data = request.json
    if not all(key in data for key in ['username', 'receiver', 'pokemon']):
        return jsonify({"error": "Missing required fields"}), 400
        
    username = data['username']
    receiver = data['receiver']
    pokemon = str(data['pokemon'])
    
    try:
        cursor = mysql.connection.cursor()
        cursor.execute(
            "SELECT pokelist FROM Pokedex WHERE username = %s AND JSON_CONTAINS(pokelist, %s)",
            (username, json.dumps(pokemon))
        )
        sender_data = cursor.fetchone()
        if not sender_data:
            return jsonify({"error": "Pokemon not found in sender's list"}), 404
        cursor.execute(
            "SELECT 1 FROM Pokedex WHERE username = %s",
            (receiver,)
        )
        if not cursor.fetchone():
            return jsonify({"error": "Receiver not found"}), 404
        cursor.execute(
            "UPDATE Pokedex SET pokelist = JSON_REMOVE(pokelist, JSON_UNQUOTE(JSON_SEARCH(pokelist, 'one', %s))) WHERE username = %s",
            (pokemon, username)
        )
        cursor.execute(
            "UPDATE Pokedex SET pokelist = CASE "
            "WHEN pokelist IS NULL THEN JSON_ARRAY(%s) "
            "ELSE JSON_ARRAY_APPEND(pokelist, '$', %s) "
            "END WHERE username = %s",
            (pokemon, pokemon, receiver)
        )
        
        mysql.connection.commit()
        return jsonify({"message": "Pokemon traded successfully"}), 200
        
    except Exception as e:
        print(f"Trade error: {e}")
        mysql.connection.rollback()
        return jsonify({"error": f"Trade failed: {str(e)}"}), 500
    finally:
        cursor.close()

@app.route('/pokemon_image/<pokemon_id>')
@cross_origin()
def get_pokemon_image(pokemon_id):
    try:
        data = requests.get(f'https://pokeapi.co/api/v2/pokemon/{pokemon_id}')
        if data.status_code == 200:
            data = data.json()
            image_url = data['sprites']['other']['official-artwork']['front_default']
            if not image_url:
                image_url = data['sprites']['front_default']
            image_response = requests.get(image_url)
            if image_response.status_code == 200:
                return Response(
                    image_response.content,
                    content_type=image_response.headers['Content-Type']
                )
        return jsonify({"error": "Image not found"}), 404
    except Exception as e:
        print(f"Error fetching Pokemon image: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/pokemon/<pokemon_name>')
@cross_origin()
def get_pokemon_by_name(pokemon_name):
    try:
        github_response = requests.get('https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json')
        if github_response.status_code == 200:
            data = github_response.json()
            pokemon_list = data['pokemon']
            pokemon_name = pokemon_name.lower()
            pokemon = next((p for p in pokemon_list if p['name'].lower() == pokemon_name), None)
            if pokemon:
                pokemon_id = pokemon['id']
                pokemon['img'] = f'/pokemon_image/{pokemon_id}'
                return jsonify(pokemon)
            
        return jsonify({"error": "Pokemon not found"}), 404
    
    except Exception as e:
        print(f"Error fetching Pokemon data: {e}")
        return jsonify({"error": str(e)}), 500
   
if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5001)