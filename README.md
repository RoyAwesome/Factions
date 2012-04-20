# Empires UDK

This is the development repository for Empires UDK.

## Installation

1. [Download and install UDK](http://udk.com/download).
2. Clone this repository to your UDK installation directory (e.g. `C:\UDK\UDK-2012-03`).
3. In _UDKGame/Config/DefaultEngine.ini_, under section _[URL]_, set `Map=TestMap.udk` and `LocalMap=TestMap.udk`. At the end of section [UnrealEd.EditorEngine], add `+EditPackages=EmpGame`. 
4. In _UDKGame/Config/DefaultGame.ini_, under section _[Engine.GameInfo]_, set `DefaultGame=EmpGame.EmpTeamGame`, `DefaultServerGame=EmpGame.EmpTeamGame`, and `DefaultGameType="EmpGame.EmpTeamGame";`.
5. Compile the scripts.

## Updating

**Important:** Always pull using **rebase**. Do not use merge because this will cause a non-linear history.

## Content Repositories

These repositories will usually be behind the development repository. They are stable versions that can be used by content creators who don't have source code access.

* [empires-udk-unrealscript](https://bitbucket.org/jephir/empires-udk-unrealscript)
* [empires-udk-content](https://bitbucket.org/jephir/empires-udk-content)
* [empires-udk-maps](https://bitbucket.org/jephir/empires-udk-maps)
* [empires-udk-flash](https://bitbucket.org/jephir/empires-udk-flash)