<#
Copyright 2016 ASOS.com Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

<#
.NAME
	Get-VariableFromScriptFile.Tests

.SYNOPSIS
	Pester tests for Get-VariableFromScriptFile.
#>
Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
. "$here\Get-VariableStatement.ps1"

Describe "Get-VariableFromScriptFile" {
    BeforeEach {
        $tempFile = [System.IO.Path]::GetTempFileName() # Cant use the testdrive as $doc.Save($Path) doesn't support 'TestDrive:\'
        Set-Content $tempFile @"
function test {
    `$myTestVariable = 'some value'
    Write-Host `$myTestVariable
}
"@
    }
    AfterEach {
        Remove-Item $tempFile
    }
    
    It "Should get the value of the variable from a script" {
        Get-VariableFromScriptFile -Path $tempFile -Variable "myTestVariable" | Should Be "some value"
    }
    
    It "Should get the variable statement from a script" {
        Get-VariableFromScriptFile -Path $tempFile -Variable "myTestVariable" -DontResolveVariable | Should Be "'some value'"
    }
    
    It "Should throw an exception if the variable doest exist" {
        { Get-VariableFromScriptFile -Path $tempFile -Variable "null1" } | Should Throw
    }
}
