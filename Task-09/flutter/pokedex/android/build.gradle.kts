allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

// Use project.afterEvaluate to safely access layout.buildDirectory
subprojects {
    afterEvaluate {
        buildDir = File(rootProject.projectDir, "../../build/${project.name}")
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
