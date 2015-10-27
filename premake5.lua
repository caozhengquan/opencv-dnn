-- http://industriousone.com/scripting-reference
-- https://github.com/premake/premake-core/wiki

local action = _ACTION or ""

solution "opencv-dnn"
    location ("_project")
    configurations { "Debug", "Release" }
    platforms {"x64", "x32"}
    language "C++"
    targetdir ("bin")
    kind "StaticLib"

    configuration "vs*"
        defines { "_CRT_SECURE_NO_WARNINGS" }

    flags {
        "MultiProcessorCompile"
    }

    configuration "Debug"
        targetdir ("bin")
        defines { "DEBUG" }
        flags { "Symbols"}
        targetsuffix "-d"

    configuration "Release"
        defines { "NDEBUG" }
        flags { "Optimize"}

    project "opencv-dnn"
        includedirs {
            "include",
            "src",
            "../opencv-lib/include/",
            "3rdparty/protobuf/src/",
        }

        files { 
            "include/opencv2/dnn/*",
            "src/*",
            "src/caffe/*",
            "src/layers/*",
            "src/opencl/*",
            "src/torch/*",
        }

        libdirs {
            "../opencv-lib/vs2013-x86"
        }

        defines {
            "HAVE_PROTOBUF=1"
        }

        configuration "Debug"
            links {
                "opencv_world300d.lib"
            }
        configuration "Release"
            links {
                "opencv_world300.lib"
            }

