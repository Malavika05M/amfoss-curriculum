# Introduction
Letterboxd is an online social cataloging service for film. Members can rate and review films, keep track of which ones they have seen in the past and when, make lists of films, showcase their favorites, tag films using text keywords, and interact with other cinephiles.
This document details the functional and non-functional requirements of Letterboxd, including its scope, system features, and design constraints.

# Scope
Letterboxd allows users to:

- Log and rate films they have watched.
- Write and share reviews
- Create and manage wishlists.
- Discover movies through recommendations and curated lists.
- Engage with a community of film enthusiasts.

## References
- GeeksforGeeks manual on how to write a SRS document
- Letterboxd Website

# Overall Description
## Product Perspective
Letterboxd is a standalone product but can integrate with third-party services such as IMDb and TMDb for movie metadata. It will feature a user-friendly UI and leverage AI for recommendations.
## Product Functions
- User Authentication
- Movie Logging
- Watchlist Management
- Community Features
- Recommendations
## User Characteristics
- Casual users
- Avid movie enthusiasts
- Film critics
## Constraints
- The application must handle high user traffic efficiently.
- Ensure GDPR compliance for user data.
- Limited to English at launch, with plans for localization.
## Assumptions and Dependencies
- Users will have internet access
- Third party APIs(IMDb, TMDb) will be accessible and reliable.

# Specific Requirements
## Functional Requirements
1. **User Authentication**: Users can register, log in and reset passwords.
2. **Movie Logging**: Search for movies and log them with ratings(1-5 stars).
3. **Watchlist Management**: Add movies to a personal watchlist.
4. **Social Features**: Users can comment on and like reviews
5. **Recommendations**: Display personalized movie suggestions.
## Non-Functional Requirements
- **Performance**: Response time for seraches must not exceed 2 seconds.
- **Scalability**: The system should handle 1M active users concurrently.
- **Security**: User data must be encrypted in transit and at rest.
- **Usability**: The application must adhere to accesibility standards.
## Interface Requirements
- **Web Interface**: Compatible with major browsers(Chrome, firefox, safari).
- **Mobile Interface**: Native apps for iOS and Android.
- **API**: RESTful API for integration with third-party services.

# Appendices
## Appendix A: Glossary
- **CRUD**: Basic data operations
- **API**: Set of functions for application communication.
## Appendix B: References
- Vidyaratna Curriculum
