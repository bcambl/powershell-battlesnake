
BeforeAll {
    # import our logic to be tested
    . .\Add-Logic.ps1
}

Describe 'Get-Move' {
    It 'Avoids Neck Move' {
        $me = [PSCustomObject]@{
            head = [PSCustomObject]@{
                x = 2
                y = 0
            }
            body = @(
                [PSCustomObject]@{
                    x = 2
                    y = 0
                }
                [PSCustomObject]@{
                    x = 1
                    y = 0
                }
                [PSCustomObject]@{
                    x = 0
                    y = 0
                }
            )
        }
        $board = [PSCustomObject]@{
            snakes = @($me)
        }
        $state = [PSCustomObject]@{
            board = $board
            you = $me
        }
        $gameState = $state | ConvertTo-Json -Depth 10
        for ($i=0; $i -le 10; $i++) {
            $moveJson = Get-Move $gameState | ConvertFrom-Json
            $moveJson.move | Should -Not -Be "left"
        }
    }
}
