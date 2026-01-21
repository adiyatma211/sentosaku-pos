allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Fix for flutter_bluetooth_serial namespace issue
    subprojects {
        if (project.name == "flutter_bluetooth_serial") {
            afterEvaluate {
                if (project.hasProperty("android")) {
                    val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
                    android.namespace = "com.devlabs.flutterbluetoothserial"
                    
                    // FIX: Set compileSdk to 36 to support dependencies (requires API 36+)
                    android.compileSdkVersion(36)
                    
                    // Update Java compatibility to avoid obsolete Java 8 warnings
                    android.compileOptions {
                        sourceCompatibility = JavaVersion.VERSION_17
                        targetCompatibility = JavaVersion.VERSION_17
                    }
                    
                    // Use our custom AndroidManifest.xml without the package attribute
                    android.sourceSets {
                        getByName("main") {
                            manifest.srcFile("../flutter_bluetooth_serial_fixed/src/main/AndroidManifest.xml")
                        }
                    }
                }
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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
