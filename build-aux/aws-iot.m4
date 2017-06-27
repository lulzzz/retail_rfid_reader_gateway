
# aws-iot.m4: Locate AWS IoT device sdk headers and libraries for 
# autoconf-based projects.
# Copyright (C) 2017 TangCheng <ctang@thoughtworks.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Additional permission under section 7 of the GNU General Public
# License, version 3 ("GPLv3"):
#
# If you convey this file as part of a work that contains a
# configuration script generated by Autoconf, you may do so under
# terms of your choice.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# AWS_IOT_SDK_CPP_REQUIRE([ACTION-IF-NOT-FOUND])
# -----------------------------------------------
# Look for AWS IoT device sdk for C++.  If version is given, it must either 
# be a literal of the form "X.Y.Z" where X, Y and Z are integers (the ".Z" 
# part being optional) or a variable "$var".
# Defines the value AWS_IOT_CPPFLAGS.  This macro checks for headers and
# libraries with the required version.
# On # success, defines HAVE_AWS_IOT_SDK_CPP. On failure, calls the optional
# ACTION-IF-NOT-FOUND action if one was supplied.
# Otherwise aborts with an error message.
AC_DEFUN_ONCE([AWS_IOT_SDK_CPP_REQUIRE],
[AC_REQUIRE([AC_PROG_CXX])dnl
echo "$as_me: this is aws-iot.m4[]" >&AS_MESSAGE_LOG_FD
AC_ARG_WITH([aws_iot_sdk_cpp],
    [AC_HELP_STRING([--with-aws-iot-sdk-cpp=DIR], 
                    [aws iot device sdk for C++ install dir @<:@guess@:>@])])dnl
AC_ARG_VAR([AWS_IOT_SDK_CPP_ROOT],[Location of aws_iot_sdk_cpp installation])dnl
# If AWS_IOT_SDK_CPP_ROOT is set and the user has not provided a value to
# --with-aws-iot-sdk-cpp, then treat AWS_IOT_SDK_CPP_ROOT as if it the user supplied it.
if test x"$AWS_IOT_SDK_CPP_ROOT" != x; then
  if test x"$with_aws_iot_sdk_cpp" = x; then
    AC_MSG_NOTICE([Detected AWS_IOT_SDK_CPP_ROOT; continuing with --with-aws_iot_sdk_cpp=$AWS_IOT_SDK_CPP_ROOT])
    with_aws_iot_sdk_cpp=$AWS_IOT_SDK_CPP_ROOT
  else
    AC_MSG_NOTICE([Detected AWS_IOT_SDK_CPP_ROOT=$AWS_IOT_SDK_CPP_ROOT, but overridden by --with-aws_iot_sdk_cpp=$with_aws_iot_sdk_cpp])
  fi
fi
AC_SUBST([DISTCHECK_CONFIGURE_FLAGS],
         ["$DISTCHECK_CONFIGURE_FLAGS '--with-aws-iot-sdk-cpp=$with_aws_iot_sdk_cpp'"])dnl
aws_iot_sdk_cpp_save_cppflags=$CPPFLAGS
aws_iot_sdk_cpp_save_ldflags=$LDFLAGS
aws_iot_sdk_cpp_save_libs=$LIBS
aws_iot_sdk_cpp_found=no
  AC_CACHE_CHECK([for AWS IoT device sdk for C++ headers version],
    [aws_iot_sdk_cpp_cv_path],
    [aws_iot_sdk_cpp_cv_path=""
AC_LANG_PUSH([C++])dnl
    for awsdir in $with_aws_iot_sdk_cpp "" $prefix /usr/local ; do
        LDFLAGS="$aws_iot_sdk_cpp_save_ldflags"
        LIBS="$aws_iot_sdk_cpp_save_libs -laws-iot-sdk-cpp"
        CPPFLAGS="$aws_iot_sdk_cpp_save_cppflags"

        # skip the directory if it isn't there
        if test ! -z "$awsdir" -a ! -d "$awsdir" ; then
            continue;
        fi
        if test ! -z "$awsdir" ; then
            if test -d "$awsdir/lib" ; then
                LDFLAGS="-L$awsdir/lib $LDFLAGS"
            else
                LDFLAGS="-L$awsdir $LDFLAGS"
            fi
            if test -d "$awsdir/include" ; then
                CPPFLAGS="-I$awsdir/include $CPPFLAGS"
            else
                CPPFLAGS="-I$awsdir $CPPFLAGS"
            fi
        fi

        # can I compile and link it?
        AC_TRY_LINK([#include <iostream>
                     #include <util/logging/Logging.hpp>],
                    [awsiotsdk::util::Logging::ShutdownAWSLogging()],
                    [aws_iot_sdk_cpp_linkd=yes],
                    [aws_iot_sdk_cpp_linkd=no])
        if test $aws_iot_sdk_cpp_linkd = yes; then
            if test ! -z "$awsdir" ; then
                aws_iot_sdk_cpp_cv_path=$awsdir
            else
                aws_iot_sdk_cpp_cv_path="(system)"
            fi
            aws_iot_sdk_cpp_found=yes
            break
        fi
    done
    if test $aws_iot_sdk_cpp_found = no; then
        aws_iot_sdk_cpp_errmsg="AWS IoT device sdk for C++ not found."
        AC_MSG_ERROR([$aws_iot_sdk_cpp_errmsg])
        m4_if([$1], [], [AC_MSG_ERROR([$aws_iot_sdk_cpp_errmsg])],
                        [AC_MSG_NOTICE([$aws_iot_sdk_cpp_errmsg])])
        $1
    fi
AC_LANG_POP([C++])dnl
    ])
    AWS_IOT_LIBS="-laws-iot-sdk-cpp"
    AC_SUBST(AWS_IOT_LIBS)
    if test $aws_iot_sdk_cpp_cv_path != "(system)"; then
        if test -d "$aws_iot_sdk_cpp_cv_path/lib" ; then
            AWS_IOT_LDFLAGS="-L$aws_iot_sdk_cpp_cv_path/lib"
        else
            AWS_IOT_LDFLAGS="-L$aws_iot_sdk_cpp_cv_path"
        fi
        AC_SUBST(AWS_IOT_LDFLAGS)
        if test -d "$aws_iot_sdk_cpp_cv_path/include" ; then
            AWS_IOT_CPPFLAGS="-I$aws_iot_sdk_cpp_cv_path/include"
        else
            AWS_IOT_CPPFLAGS="-I$aws_iot_sdk_cpp_cv_path"
        fi
        AC_SUBST(AWS_IOT_CPPFLAGS)
    fi
LIBS="$aws_iot_sdk_cpp_save_libs"
LDFLAGS="$aws_iot_sdk_cpp_save_ldflags"
CPPFLAGS="$aws_iot_sdk_cpp_save_cppflags"
])# AWS_IOT_SDK_CPP_REQUIRE
