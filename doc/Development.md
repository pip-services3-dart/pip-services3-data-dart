# Development and Testing Guide <br/> Pip.Services Data for Dart

This document provides high-level instructions on how to build and test the microservice.

* [Environment Setup](#setup)
* [Installing](#install)
* [Building](#build)
* [Testing](#test)
* [Release](#release)
* [Contributing](#contrib) 

## <a name="setup"></a> Environment Setup

This is a Dart project and you have to install Dart tools. 
You can download them from official Dart website: https://dart.dev/get-dart 

After Dart is installed you can check it by running the following command:
```bash
dart --version
pub version
```
To work with GitHub code repository you need to install Git from: https://git-scm.com/downloads

## <a name="install"></a> Installing

After your environment is ready you can check out source code from the Github repository:
```bash
git clone git@github.com/pip-services3-dart/pip-services3-data-dart.git
```

Then go to the project folder and install dependent modules:

```bash
# Install dependencies compiler
# Run this command form root folder of your project
pub get

```

If you worked with the microservice before you can check out latest changes and update the dependencies:
```bash
# Update source code updates from github
git pull

```

## <a name="build"></a> Building

The data is written in TypeScript language which is transcompiled into JavaScript.
So, if you make changes to the source code you need to compile it before running or committing to github.

```bash
pub run
```


## <a name="test"></a> Testing

Before you execute tests you need to set configuration options in config.json file.
As a starting point you can use example from config.example.json:

```bash
copy config/config.example.yaml config/config.yaml
``` 

After that check all configuration options. Specifically, pay attention to connection options
for database and dependent microservices. For more information check [Configuration Guide](Configuration.md) 

Command to run unit tests:
```bash
pub run test
```

You can also execute benchmarks as:
```bash
npm run benchmark
```

## <a name="release"></a> Release

Formal release process consistents of few steps. 
First of all it is required to tag guthub repository with a version number:

```bash
git tag vx.y.y
git push origin master --tags
```

Then the release can be pushed to the global **pub.dev** repository. 
To be able to make the release contributor must have an account with proper
permissions at **pub.dev** site.
See https://dart.dev/tools/pub/cmd/pub-lish for detailed documentation.

```bash
pub publish
```

Microservice releases additionally require generation and publishing 
binary packages at http://downloads.pipservices.org

## <a name="contrib"></a> Contributing

Developers interested in contributing should read the following instructions:

- [How to Contribute](http://www.pipservices.org/contribute/)
- [Guidelines](http://www.pipservices.org/contribute/guidelines)
- [Styleguide](http://www.pipservices.org/contribute/styleguide)
- [ChangeLog](../CHANGELOG.md)

> Please do **not** ask general questions in an issue. Issues are only to report bugs, request
  enhancements, or request new features. For general questions and discussions, use the
  [Contributors Forum](http://www.pipservices.org/forums/forum/contributors/).

It is important to note that for each release, the [ChangeLog](../CHANGELOG.md) is a resource that will
itemize all:

- Bug Fixes
- New Features
- Breaking Changes