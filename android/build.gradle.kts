import org.gradle.api.initialization.resolve.RepositoriesMode

buildscript {
  repositories {
    google()
    mavenCentral()
  }
  dependencies {
    // Flutter’s Android Gradle plugin:
    classpath("com.android.tools.build:gradle:7.4.2")
    // Google services plugin for Firebase:
    classpath("com.google.gms:google-services:4.3.15")
  }
} 

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
plugins {
  id("com.google.gms.google-services") version "4.4.3" apply false
}
