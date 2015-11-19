-- http://industriousone.com/scripting-reference
-- https://github.com/premake/premake-core/wiki

local action = _ACTION or ""

solution "opencv-dnn"
    location ("_project")
    configurations { "Debug", "Release" }
    platforms {"x64", "x86"}
    language "C++"
    kind "StaticLib"

    configuration "vs*"
        defines { "_CRT_SECURE_NO_WARNINGS" }

        configuration "x86"
            libdirs {
                "../opencv-lib/vs2013-x86",
                "x86",
            }
            targetdir ("x86")

        configuration "x64"
            libdirs {
                "../opencv-lib/vs2013-x64",
                "x64",
            }
            targetdir ("x64")

        os.mkdir("x86");
        os.copyfile("../opencv-lib/vs2013-x86/opencv_world300d.dll", "x86/opencv_world300d.dll")
        os.copyfile("../opencv-lib/vs2013-x86/opencv_world300.dll", "x86/opencv_world300.dll")
        os.mkdir("x64");
        os.copyfile("../opencv-lib/vs2013-x64/opencv_world300d.dll", "x64/opencv_world300d.dll")
        os.copyfile("../opencv-lib/vs2013-x64/opencv_world300.dll", "x64/opencv_world300.dll")

    flags {
        "MultiProcessorCompile"
    }

    configuration "Debug"
        defines { "DEBUG" }
        flags { "Symbols"}
        targetsuffix "-d"

    configuration "Release"
        defines { "NDEBUG" }
        flags { "Optimize"}

    configuration "Debug"
        links {
            "opencv_world300d.lib"
        }
    configuration "Release"
        links {
            "opencv_world300.lib"
        }

--
    project "opencv-dnn"
        includedirs {
            "include",
            "src",
            "../opencv-lib/include/",
            "3rdparty/protobuf/src/",
            "3rdparty/protobuf/cmake/",
        }

        files { 
            "include/opencv2/dnn/*",
            "src/*",
            "src/caffe/*",
            "src/layers/*",
            "src/opencl/*",
            "src/torch/*",
        }

        files {
            "3rdparty/protobuf/src/google/protobuf/*",
            "3rdparty/protobuf/src/google/protobuf/io/*",
            "3rdparty/protobuf/src/google/protobuf/stubs/*",
        }

        excludes {
            "3rdparty/protobuf/src/google/protobuf/*test*",
            "3rdparty/protobuf/src/google/protobuf/io/*test*",
            "3rdparty/protobuf/src/google/protobuf/stubs/*test*",
        }

        defines {
            "HAVE_PROTOBUF=1"
        }

--
    function create_app_project( app_path )
        leaf_name = string.sub(app_path, string.len("apps/") + 1);

        project (leaf_name)
            kind "ConsoleApp"

            includedirs {
                "include",
                "../opencv-lib/include",
            }

            files {
                "apps/" .. leaf_name .. "/*",
            }

            configuration "Debug"
                links {
                    "opencv-dnn-d.lib",
                }
            configuration "Release"
                links {
                    "opencv-dnn.lib",
                }
    end

    local apps = os.matchdirs("apps/*")
    for _, app in ipairs(apps) do
        create_app_project(app)
    end
