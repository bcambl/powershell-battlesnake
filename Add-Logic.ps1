
# Snake logic can go here.
# Basic 'neck' avoidance has already been provided. Refer to the TODO comments for next steps.


# This function is called when you register your Battlesnake on play.battlesnake.com
# See https://docs.battlesnake.com/guides/getting-started#step-4-register-your-battlesnake
# It controls your Battlesnake appearance and author permissions.
# For customization options, see https://docs.battlesnake.com/references/personalization
# TIP: If you open your Battlesnake URL in browser you should see this data.
function Get-Info {
    Write-Host "INFO"
    $info = [PSCustomObject]@{
        apiversion = '1'
        author = ''        # TODO: Your Battlesnake username
        color = '#012456'  # TODO: Personalize
        head = "default"   # TODO: Personalize
        tail = "default"   # TODO: Personalize
        version = "0.0.0"  # Optional
    }
    [string]$json = $info | ConvertTo-Json
    return $json
}

# This function is called everytime your Battlesnake is entered into a game.
# The provided gameState contains information about the game that's about to be played.
# It's purely for informational purposes, you don't have to make any decisions here.
function Start-Game {
    param (
        [string]$gameState
    )
    $state = $gameState | ConvertFrom-Json -Depth 10
    Write-Host "$($state.game.id):  START"
}

# This function is called when a game your Battlesnake was in has ended.
# It's purely for informational purposes, you don't have to make any decisions here.
function Stop-Game {  # 'End' is not an approved powershell verb. see: Get-Verb
    param (
        [string]$gameState
    )
    $state = $gameState | ConvertFrom-Json -Depth 10
    Write-Host "$($state.game.id):  END"
}

# This function is called on every turn of a game. Use the provided gameState to decide
# where to move -- valid moves are "up", "down", "left", or "right".
function Get-Move {

    param (
        [string]$gameState
    )

    # Refer to the 'object definitions' documentation for the currrent structure of $gameState
    # https://docs.battlesnake.com/references/api#object-definitions
    $state = $gameState | ConvertFrom-Json -Depth 10

    $possibleMoves = [PSCustomObject]@{
        up = $true
        down = $true
        left = $true
        right = $true
    }

    # Step 0: Don't let your Battlesnake move back in on it's own neck
    [PSCustomObject]$head = $state.you.body[0]
    [PSCustomObject]$neck = $state.you.body[1]

    if ($head.y -lt $neck.y) {
        $possibleMoves.up = $false
    }
    if ($head.y -gt $neck.y) {
        $possibleMoves.down = $false
    }
    if ($head.x -gt $neck.x) {
        $possibleMoves.left = $false
    }
    if ($head.x -lt $neck.x) {
        $possibleMoves.right = $false
    }

    # TODO: Step 1 - Don't hit walls.

    # TODO: Step 2 - Don't hit yourself.

    # TODO: Step 3 - Don't collide with others.

    # TODO: Step 4 - Find food.

    # Finally, choose a move from the available safe moves.
	# TODO: Step 5 - Select a move to make based on strategy, rather than random.
    [string]$nextMove = ""

    $safeMoves = @()
    if ($possibleMoves.up -eq $true) {
        $safeMoves += "up"
    }
    if ($possibleMoves.down -eq $true) {
        $safeMoves += "down"
    }
    if ($possibleMoves.left -eq $true) {
        $safeMoves += "left"
    }
    if ($possibleMoves.right -eq $true) {
        $safeMoves += "right"
    }

    if ($safeMoves.Length -eq 0) {
        $nextMove = "right"
        Write-Host "$($state.game.id) MOVE $($state.turn): No safe moves. Moving $($nextMove)"
    }
    else {
        # choose random move
        $nextMove = Get-Random -InputObject $safeMoves
    }

    Write-Host "$($state.game.id) MOVE $($state.turn): $($nextMove)"

    # build move response
    $moveResponse = [PSCustomObject]@{
        move = $nextMove
        shout = ""
    }
    [string]$json = $moveResponse | ConvertTo-Json
    return $json
}