// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// dead trycatch due to a br


.assembly extern System.Console
{
  .publickeytoken = (B0 3F 5F 7F 11 D5 0A 3A )
  .ver 4:0:0:0
}
.assembly extern mscorlib
{
  .ver 0:0:0:0
}
.assembly extern eh_common {}
.assembly 'deadtrycatch'
{
  .ver 0:0:0:0
}
.imagebase 0x00400000
.subsystem 0x00000003
.file alignment 512
.corflags 0x00000001

.class public auto ansi Test_deadtrycatch extends [mscorlib] System.Object {
.method public static int32 main() {
    .entrypoint
      .maxstack  2
      .locals init (
	  class [mscorlib]System.IO.StringWriter expectedOut,
	  class [eh_common]TestUtil.TestLog testLog
	)
    
    newobj     instance void [mscorlib]System.IO.StringWriter::.ctor()
    stloc.s    expectedOut
    ldloc.s    expectedOut
    ldstr      "In try"
    callvirt   instance void [mscorlib]System.IO.TextWriter::WriteLine(string)
    ldloc.s    expectedOut
    ldstr      "Done"
    callvirt   instance void [mscorlib]System.IO.TextWriter::WriteLine(string)
    ldloc.s    expectedOut
    newobj     instance void [eh_common]TestUtil.TestLog::.ctor(object)
    stloc.s    testLog

    ldloc.s    testLog
    callvirt   instance void [eh_common]TestUtil.TestLog::StartRecording()

      .try {
        ldstr      "In try"
        call       void [System.Console]System.Console::WriteLine(string)
	leave.s done
      dead:
        ldstr      "Unreached"
        call       void [System.Console]System.Console::WriteLine(string)
        .try
        {
	  ldstr      "In try"
          call       void [System.Console]System.Console::WriteLine(string)
          leave.s    dead
        }  
        catch [mscorlib]System.Exception
        {
          ldstr      "In catch, unreached"
          call       void [System.Console]System.Console::WriteLine(string)
          leave.s done
        }  

      } catch [mscorlib]System.Exception {
        ldstr      "In catch, unreached"
        call       void [System.Console]System.Console::WriteLine(string)
        leave.s    done        
      }

    done:  
      ldstr      "Done"
      call       void [System.Console]System.Console::WriteLine(string)
      ldloc.s    testLog
	  callvirt   instance void [eh_common]TestUtil.TestLog::StopRecording()
  
		ldloc.s    testLog
		callvirt   instance int32 [eh_common]TestUtil.TestLog::VerifyOutput()
	    ret
}
}
