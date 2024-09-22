if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Warning "このスクリプトにはPowerShell 5.0以降が必要です。"
    return # またはスクリプトを終了する
}

## 設定を変更する
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -EditMode vi
Set-PSReadLineOption -BellStyle Visual
Set-PSReadLineOption -Key tab -function MenuComplete

## コンソール入力画面を変更する
function Prompt
{
    # プロンプト文字列を定義
    $promptString = "PS " + $(Get-Location) + ">"
    $isAdmin = '>$'

    # 現在のユーザが管理者かどうか判定
    if(([Secutiry.Principal.Windowsprincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltinRole] "Administrator"))
    {
        $isAdmin = '>$'
    }

    # Windowsコンソールの場合
    if ( $Host.Name -eq "ConsoleHost" )
    {
        # ユーザ名をDarkCyanで表示
        Write-Host ("[") -NoNewline -ForegroundColor DarkGray
        Write-Host ($env:username) -NoNewline -ForegroundColor DarkCyan
        Write-Host ("@") -NoNewline -ForegroundColor DarkGray

        # ホスト名をDarkGreenで表示
        Write-Host (hostname) -NoNewline -ForegroundColor DarkGreen
        Write-host (" ") -NoNewline -ForegroundColor DarkGray
        
        # パスをDarkYellowで表示
        Write-host (shorten-path (pwd).Path) -NoNewline -ForegroundColor DarkYellow
        Write-host ("]") -NoNewline -ForegroundColor DarkGray

        # 管理者の場合はMagentaで表示
        Write-host ($isAdmin) -NoNewline -ForegroundColor DarkBlue
    }

    # それ以外の場合はデフォルトのプロンプト文字列を表示
    return " "
}

## sorten-path関数を定義
function shorten-path([String]$path) {
    # ホームディレクトリを~に変換
    $loc = $path.Replace($HOME, '~')
    # UNCパスの先頭を削除
    $loc = $loc -replace '^[^:]+::', ''
    # Vimのタブ表示のようにパスを短縮
    # \と.から始まるパスを正しく処理
    return ($loc -replace '\\(.?)([^\\])[^\\]*(?=\\)', '$1$2')
}