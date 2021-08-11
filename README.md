<div align="center">
    <h1>ArcadePaper</h1>
    <strong>ArcadePaper is 1.8.8 patch for <a href="https://github.com/PaperMC/Paper">PaperSpigot</a> with many features.</strong><br><br>
    <img src="https://forthebadge.com/images/badges/made-with-java.svg" height="30">&nbsp;
    <img src="https://forthebadge.com/images/badges/built-with-love.svg" height="30">&nbsp;
    <br>
    <img src="https://ci.arcadiamc.cz/buildStatus/icon?job=arcadepaper%2Fmain&style=flat-square">
</div>

## Downloads
[ArcadePaperclip](https://ci.arcadiamc.cz/job/ArcadePaper/job/main/lastSuccessfulBuild/artifact/arcadepaperclip.jar)

## API

### [Javadoc](https://ci.arcadiamc.cz/job/ArcadePaper/job/main/javadoc/index.html)

### Dependency Information
Maven
```xml
<repository>
    <id>arcadiamc</id>
    <url>https://nexus.arcadiamc.cz/repository/maven-public/</url>
</repository>
```
```xml
<dependency>
    <groupId>cz.arcadiamc</groupId>
    <artifactId>arcadepaper-api</artifactId>
    <version>1.8.8-R0.1-SNAPSHOT</version>
    <scope>provided</scope>
</dependency>
```

Gradle
```groovy
repositories {
  maven {
      url 'https://nexus.arcadiamc.cz/repository/maven-public/'
  }
}
```
```groovy
dependencies {
    compileOnly 'cz.arcadiamc:arcadepaper-api:1.8.8-R0.1-SNAPSHOT'
}
```

This also includes all API provided by PaperSpigot, Spigot and Bukkit.

## Building and setting up

#### Initial setup
Run the following commands in the root directory:

```shell
./arcadepaper build
```

#### Creating a patch
Patches are effectively just commits in `ArcadePaper-API` and `ArcadePaper-Server`.
To create one, just add a commit to one of repos and run `./arcadepaper rebuild`, and a
patch will be placed in the patches folder. Modifying commits will also modify its
corresponding patch file.

#### Compiling

Use the command `./arcadepaper build` to build the server. ArcadePaper jar
will be placed under `ArcadePaper-Server/target/arcadepaper-1.8.8-R0.1-SNAPSHOT.jar`.