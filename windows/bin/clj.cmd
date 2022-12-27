@echo off

set clojure_dir=C:\bin\clojure

REM required until I figure out why the classpath isn't working.
cd %clojure_dir%

java -cp clojure-1.5.1.jar clojure.main %*
