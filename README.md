PowerShell Battlesnake QuickStart
=================================

A Starter Battlesnake written in PowerShell Core 7 based on [community created starter project guidelines](https://docs.battlesnake.com/references/starter-projects#contributing-your-own-starter-project).

Learn more at https://play.battlesnake.com/

## Customizing Your Battlesnake
Update the `Get-Info` function found inside [Add-Logic.ps1](Add-Logic.ps1#L11)
```
$info = [PSCustomObject]@{
    apiversion = '1'
    author = ''        # TODO: Your Battlesnake username
    color = '#012456'  # TODO: Personalize
    head = "default"   # TODO: Personalize
    tail = "default"   # TODO: Personalize
    version = "0.0.1"
}
```
Refer to [Battlesnake Personalization](https://docs.battlesnake.com/references/personalization) for how to customize your Battlesnake's appearance using these values.

## Changing Behavior
On every turn of each game your Battlesnake receives information about the game board and must decide its next move.

Locate the `Get-Move` function inside [Add-Logic.ps1](Add-Logic.ps1#L49). Possible moves are "up", "down", "left", or "right" and initially your Battlesnake will choose a move randomly. Your goal as a developer is to read information sent to you about the game (available in the `$gameState` variable) and decide where your Battlesnake should move next. All your Battlesnake logic lives in [Add-Logic.ps1](Add-Logic.ps1), and this is the code you will want to edit.  
Refer to the ['object definitions' documentation](https://docs.battlesnake.com/references/api#object-definitions) for the structure of `$gameState`.

See the [Battlesnake Game Rules](https://docs.battlesnake.com/references/rules) for more information on playing the game, moving around the board, and improving your algorithm.

## Running Your Battlesnake
### Run Locally
```
pwsh Start-BattleSnake.ps1
```


### Run As Container

Build
```
podman build -t powershell-battlesnake -f Containerfile
```

Run
```
podman run -dt -p 8080:8080 --name powershell-battlesnake localhost/powershell-battlesnake
```

Test
```
curl http://localhost:8080/
```

Stop
```
podman stop powershell-battlesnake
```

## Running Tests
Install Pester
```
Install-Module Pester -Force
Import-Module Pester -PassThru
```
Run All Tests
```
Invoke-Pester -Output Detailed ./*.Tests.ps1
```

Example Test Output:
```
Pester v5.3.2

Starting discovery in 1 files.
Discovery found 1 tests in 3ms.
Running tests.

Running tests from '/home/bcambl/workspace/powershell-battlesnake/Add-Logic.Tests.ps1'
Describing Get-Move
  [+] Avoids Neck Move 2.07s (2.07s|2ms)
Tests completed in 2.1s
Tests Passed: 1, Failed: 0, Skipped: 0 NotRun: 0

```