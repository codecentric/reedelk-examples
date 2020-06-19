@echo off

PATH %PATH%;%JAVA_HOME%\bin\
for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k"

if %jver% geq 110 (
java -cp "bin/runtime.jar;lib/*" -Dio.netty.allocator.type=unpooled --add-opens java.base/java.net=ALL-UNNAMED --add-opens java.base/jdk.internal.misc=ALL-UNNAMED com.reedelk.runtime.Launcher
) else (
java -cp "bin/runtime.jar;lib/*" -Dio.netty.allocator.type=unpooled com.reedelk.runtime.Launcher
)