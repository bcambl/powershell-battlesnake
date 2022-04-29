# load logic
. .\Add-Logic.ps1

# instantiate http server
$http = [System.Net.HttpListener]::new()

# set listening address & port
$http.Prefixes.Add("http://*:8080/")

# start server
$http.Start()

# log server started
if ($http.IsListening) {
    write-host "PowerShell BattleSnake Server Started: $($http.Prefixes)"
}

# handle requests
try {
    while ($http.IsListening) {

        # get request context
        $context = $http.GetContext()


        # base status/info endpoint
        if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/') {

            [string]$json = Get-Info

            # send response
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
            $context.Response.ContentLength64 = $buffer.Length
            $context.Response.AddHeader("Content-Type", "application/json")
            $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
            $context.Response.OutputStream.Close()
        }

        # game start
        if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/start') {

            [string]$gameState = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()

            Start-Game $gameState
        }

        # game end
        if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/end') {
            [string]$gameState = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()

            Stop-Game $gameState
        }

        # game move
        if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/move') {
            [string]$gameState = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()

            [string]$json = Get-Move $gameState

            # send response
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
            $context.Response.ContentLength64 = $buffer.Length
            $context.Response.AddHeader("Content-Type", "application/json")
            $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
            $context.Response.OutputStream.Close()
        }
    }
}
finally {
    write-host "PowerShell BattleSnake Server Stopped"
}

