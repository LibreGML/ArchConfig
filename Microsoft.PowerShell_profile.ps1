## 配置oh-my-posh
# 字体补丁 https://gitee.com/Senkita/nerd-fonts-patcher/releases/
#  Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://gitee.com/ylchenxd/oh-my-posh/raw/main/install.ps1'))
#  winget upgrade oh-my-posh
#  oh-my-posh version
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted
# new-item -type file -path $profile -force
# 写入如下配置
[System.Console]::OutputEncoding=[System.Text.Encoding]::GetEncoding(65001) # 配置默认编码
 oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression # 配置oh-my-posh的theme




## 配置autocd
#  Install-Module cd-extras
#  Import-Module cd-extras
#  Add-Content $PROFILE `n, 'Import-Module cd-extras'
Import-Module cd-extras

## 配置PSReadLine
# Install-Module PSReadLine
# Import-Module PSReadLine
Import-Module PSReadLine

# 历史记录搜索长久化，不仅局限于单个会话
$options = @{
    HistoryNoDuplicates           = $True
    AddToHistoryHandler           = {
        Param([String]$line)
        return $line[0] -ne ' ' -and $line.Length -gt 5
    }
    HistorySearchCursorMovesToEnd = $True
}

Set-PSReadLineOption @options

#-------------------------------  Set Hot-keys BEGIN  -------------------------------
# 设置预测文本来源为历史记录
Set-PSReadLineOption -PredictionSource History

# 每次回溯输入历史，光标定位于输入内容末尾
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# 设置 Tab 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#-------------------------------  Set Hot-keys END    -------------------------------


## gsudo直接下载安装即可

## winfetch
#Install-Script -Name winfetch


## 别名配置
Set-Alias nvim notepad
Set-Alias ifconfig ipconfig
Set-Alias sys sysdm.cpl

## 多余修饰
winfetch
echo " < ===== 葛墨林的Powershell ===== > "

