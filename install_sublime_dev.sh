#!/usr/bin/env bash
#
# @author Zeus Intuivo <zeus@intuivo.com>
#
#
set -E -o functrace   # Strict and Report Errors
. ./execute_as_sudo.sh
. ./add_error_trap.sh
echo hei
exit 0
load_execute_command(){
    # : Execute "${@}"
    #
    # !!! ¡ ☠ Say error "${@}" and exit
    #
    # - Anounce "${@}"
    # · • Say "${@}"
    # “ Comment "${@}"
    #
    local URL=""
    local EXECOMCLI=""
    local provider=""
    [ -d "/_/clis/execute_command_intuivo_cli/" ] &&  provider="file:///_/clis/execute_command_intuivo_cli/"
    [ ! -d "/_/clis/execute_command_intuivo_cli/" ] && provider="https://raw.githubusercontent.com/zeusintuivo/execute_command_intuivo_cli/master/"
    local BASH_SCRIPTS="
execute_command
struct_testing

"
    while read -r ONE_SCRIPT; do
        # if not empty
        if [ ! -z "${ONE_SCRIPT}" ] ; then
            URL="${provider}${ONE_SCRIPT}"
            EXECOMCLI=$(curl $URL  2>/dev/null )   # suppress only curl download messages, but keep curl output for variable
            eval """${EXECOMCLI}"""
            anounce $URL Loaded

        fi
    done <<< "${BASH_SCRIPTS}"
    unset URL
    unset EXECOMCLI
    unset ONE_SCRIPT
    unset BASH_SCRIPTS
    unset provider
} # end function load_execute_command
load_execute_command


exit 0



function kill(){
  echo -e "\033[01;7m*** $THISSCRIPTNAME Exit ...\033[0m"
  ls -lad /opt/sublime_text/Packages/Package\ Control.sublime-package
  tree /opt/sublime_text/Packages/Package\ Control.sublime-package
  ls -lad /home/zeus/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package
  tree /home/zeus/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package
}
#trap kill ERR
trap kill EXIT
#trap kill INT


load_struct_testing_wget(){
    local provider="$USER_HOME/_/clis/execute_command_intuivo_cli/struct_testing"
    [   -e "${provider}"  ] && source "${provider}"
    [ ! -e "${provider}"  ] && eval """$(wget --quiet --no-check-certificate  https://raw.githubusercontent.com/zeusintuivo/execute_command_intuivo_cli/master/struct_testing -O -  2>/dev/null )"""   # suppress only wget download messages, but keep wget output for variable
    ( ( ! command -v passed >/dev/null 2>&1; ) && echo -e "\n \n  ERROR! Loading struct_testing \n \n " && exit 69; )
} # end load_struct_testing_wget
load_struct_testing_wget

passed Home identified:$USER_HOME
passed Caller user identified:$SUDO_USER
file_exists_with_spaces "$USER_HOME"



_version() {
    local _sublime_string=$(curl -L https://www.sublimetext.com/3dev  2>/dev/null | sed -n "/<p\ class=\"latest\">/,/<\/div>/p" | head -1)  # suppress only wget download messages, but keep wget output for variable
    local _sublime_build_line=$(echo "${_sublime_string}" | grep 'Build ....')
    if [ -z "${_sublime_build_line}" ] ; then
    {
        echo "error when doing check of line string from website. Got nothing"
        echo "    _sublime_string: <${_sublime_string}>"
        echo "                      0123456789 123456789 123456789 123456789 123456789 123456789 1234567889 123456789 123456789 123456789 123456789 "
        echo "                                1         2         3         4         5         6          7         8         9        10        11"
        echo "_sublime_build_line: <${_sublime_build_line}>"
        failed "Error"
        exit 69;
    }
    else
    {
        local SUBLIMEDEVLASTESTBUILD=$(echo "${_sublime_build_line}" | cut -c42-45)
        wait
        [[ -z "${SUBLIMEDEVLASTESTBUILD}" ]] && failed "Sublime Version not found!"
        echo "${SUBLIMEDEVLASTESTBUILD}"
    }
    fi
}

download_sublime(){
  # sample https://download.sublimetext.com/sublime-text_build-3133_amd64.deb
  # sample https://download.sublimetext.com/sublime_text_3_build_3211_x64.tar.bz2
  # https://download.sublimetext.com/sublime-text-3210-1.x86_64.rpm
  # https://download.sublimetext.com/sublime_text_3_build_3210_x32.tar.bz2
  # https://download.sublimetext.com/sublime_text_3_build_3211_x64.tar.bz2
  local target_url="https://download.sublimetext.com/${1}"

  _download "${target_url}" $USER_HOME/Downloads  ${1}

  # if ( command -v wget >/dev/null 2>&1; ) ; then
  #   wget --directory-prefix="${USER_HOME}/Downloads/" --quiet --no-check-certificate "${target_url}" 2>/dev/null
  #
  #   # echo -e "\e[7m*** Downloading file to temp location...\e[0m"
  #   # # REF: about :> http://unix.stackexchange.com/questions/37507/what-does-do-here
  #   # :> wgetrc   # here :> equals to Equivalent to the following: cat /dev/null > wgetrc which Nulls out the file called "wgetrc" in the current directory. As in creates an empty file "wgetrc" if one doesn't exist or overwrites one with nothing if it does.
  #   # echo "noclobber = off" >> wgetrc
  #   # echo "dir_prefix = ." >> wgetrc
  #   # echo "dirstruct = off" >> wgetrc
  #   # echo "verbose = on" >> wgetrc
  #   # echo "progress = bar:default" >> wgetrc
  #   # echo "tries = 3" >> wgetrc
  #
  #   # WGETRC=wgetrc wget --quiet --no-check-certificate "${target_url}" 2>/dev/null   # suppress only wget download messages, but keep wget output for variable
  #   # echo -e "\e[7m*** Download completed.\e[0m"
  #   # rm -f wgetrc
  # elif ( command -v curl >/dev/null 2>&1; ); then
  #   curl -O "${target_url}" 2>/dev/null   # suppress only wget download messages, but keep wget output for variable
  # else
  #   failed "I cannot find wget or curl to download! ${target_url}"
  # fi
}

download_install_package_control(){
  # Package Control - The Sublime Text Package Manager: https://sublime.wbond.net
  local __pc_dir_opt_s_p__=/opt/sublime_text/Packages/
  local __pc_dir_config_s_ip__=$USER_HOME/.config/sublime-text-3/Installed\ Packages/
  local __pc_download_filename__=Package\ Control.sublime-package
  local __pc_download_filepath__=$USER_HOME/$__pc_download_filename__
  local target_url="https://packagecontrol.io/Package%20Control.sublime-package"
  it_does_not_exist "${__pc_dir_opt_s_p__}" && mkdir  -p "${__pc_dir_opt_s_p__}"
  it_does_not_exist "${__pc_dir_opt_s_p__}" && mkdir -p "${__pc_dir_config_s_ip__}"
  directory_exists_with_spaces "${__pc_dir_opt_s_p__}"
  directory_exists_with_spaces "${__pc_dir_config_s_ip__}"

  if [ ! -e "${__pc_dir_opt_s_p__}" ] ; then
    failed "I cannot find target directory where sublime is installed or Packages folder! ${__pc_dir_opt_s_p__}"
  fi
  if ( command -v wget >/dev/null 2>&1; ) ; then
    wget --directory-prefix="${__pc_download_filepath__}" --quiet --no-check-certificate "${target_url}" 2>/dev/null   # suppress only wget download messages, but keep wget output for variable
  elif ( command -v curl >/dev/null 2>&1; ); then
    curl -o "${__pc_download_filepath__}" "${target_url}" 2>/dev/null   # suppress only wget download messages, but keep wget output for variable
  else
    failed "I cannot find wget or curl to download! ${target_url}"
  fi
  directory_does_not_exist_with_spaces "${__pc_download_filepath__}"
  if [ ! -e "${__pc_download_filepath__}" ] ; then
    failed "I cannot find target downloaded where the Packages was supposed to be! ${__pc_download_filepath__}"
  fi
  file_exists_with_spaces "${__pc_download_filepath__}"

  if it_exists_with_spaces "${__pc_dir_config_s_ip__}/${__pc_download_filename__}" ; then
    rm -rf "${__pc_dir_config_s_ip__}/${__pc_download_filename__}"
  fi
  sudo cp -R "${__pc_download_filepath__}"  "${__pc_dir_config_s_ip__}"

  if it_exists_with_spaces "${__pc_dir_opt_s_p__}/${__pc_download_filename__}" ; then
    rm -rf "${__pc_dir_opt_s_p__}/${__pc_download_filename__}"
  fi
  sudo cp -R "${__pc_download_filepath__}"  "${__pc_dir_opt_s_p__}"
  rm -rf "${__pc_download_filepath__}"
  if it_exists_with_spaces "${__pc_dir_config_s_ip__}/${__pc_download_filename__}/${__pc_download_filename__}" ; then
    sudo mv "${__pc_dir_config_s_ip__}/${__pc_download_filename__}/${__pc_download_filename__}" "${__pc_dir_config_s_ip__}/${__pc_download_filename__}/${__pc_download_filename__}m"
    sudo mv "${__pc_dir_config_s_ip__}/${__pc_download_filename__}/${__pc_download_filename__}m" "${__pc_dir_config_s_ip__}/"
    sudo rm -rf "${__pc_dir_config_s_ip__}/${__pc_download_filename__}m"
    sudo mv "${__pc_dir_config_s_ip__}/${__pc_download_filename__}m" "${__pc_dir_config_s_ip__}/${__pc_download_filename__}"

  fi
  sudo chown -R "${SUDO_USER}" "${__pc_dir_config_s_ip__}"
}

add_to_applications_list(){
  # Add to applications list
  directory_exists "
  ${USER_HOME}/.local/share/applications/
  /opt/sublime_text/Icon/128x128/
  /usr/share/applications/
  "


  #Creando archivo .desktop
  echo -e "\e[7m*** Creating .desktop file (for easy launch and associate to Sublime Text 3)...\e[0m"
  echo "[Desktop Entry]
  Version=1.0
  Type=Application
  Name=Sublime Text 3 DEV
  GenericName=Text Editor
  Comment=Sophisticated text editor for code, markup and prose
  #Exec=/opt/sublime_text/sublime_text %F
  Exec=sublime-text-3 %F
  Terminal=false
  MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;x-directory/normal;inode/directory;
  Icon=sublime-text-3
  Categories=TextEditor;Development;
  StartupNotify=true
  Actions=Window;Document;
  [Desktop Action Window]
  Name=New Window
  Exec=/opt/sublime_text/sublime_text -n
  OnlyShowIn=Unity;
  [Desktop Action Document]
  Name=New File
  Exec=/opt/sublime_text/sublime_text --command new_file
  OnlyShowIn=Unity;" > /usr/share/applications/"Sublime Text 3.desktop"

  cat << EOF > $USER_HOME/.local/share/applications/sublime.desktop
  [Desktop Entry]
  Name=Sublime Text Dev
  Exec=subl %F
  MimeType=text/plain;
  Terminal=false
  Type=Application
  Icon=/opt/sublime_text/Icon/128x128/sublime-text.png
  Categories=Utility;TextEditor;Development;
EOF
}

_darwin__64() {
    local SUBLIMEDEVLASTESTBUILD=$(_version)
    local SUBLIMENAME="Sublime%20Text%20Build%20${SUBLIMEDEVLASTESTBUILD}.dmg"
    local SUBLIMENAME_4_HDUTIL="Sublime Text Build ${SUBLIMEDEVLASTESTBUILD}.dmg"
    wait
    cd ~/Downloads/
    [ ! -e "${SUBLIMENAME_4_HDUTIL}" ] || download_sublime "${SUBLIMENAME}"
    echo "${pwd}"
    echo "${SUBLIMENAME_4_HDUTIL}"
    ls -la "${SUBLIMENAME_4_HDUTIL}"
    wait
    sudo hdiutil attach "${SUBLIMENAME_4_HDUTIL}"
    wait
    sudo cp -R /Volumes/Sublime\ Text/Sublime\ Text.app /Applications/
    wait
    sudo hdiutil detach /Volumes/Sublime\ Text
    wait
} # end _darwin__64

add_to_repo() {
    if  is_not_included "sublime-text" "$(dnf repolist)" ; then
    {
      sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
      # Stable
      # sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
      # Dev
      sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
    }
    fi
}
add_to_repo

_fedora__64() {
    execute_as_sudo
    add_to_repo
exit 0
    local SUBLIMEDEVLASTESTBUILD=$(_version)
    local SUBLIMEDEVLASTESTBUILD=3211
    echo $SUBLIMEDEVLASTESTBUILD
    local SUBLIMENAME="sublime-text-${SUBLIMEDEVLASTESTBUILD}-1.x86_64.rpm"
    echo $SUBLIMENAME
    wait
    cd $USER_HOME/Downloads/
    # if ! it_exists "${SUBLIMENAME}"; then
      # download_sublime "${SUBLIMENAME}"
    # fi
    wait
    sudo dnf -y install "$USER_HOME/Downloads/${SUBLIMENAME}"

    download_install_package_control
    add_to_applications_list
exit 0
    file_exists "
    /opt/sublime_text/sublime_text
    "

    wait
    if it_exists "${SUBLIMENAME}"; then
      rm -f "${SUBLIMENAME}"
    fi

    verify_is_installed "subl"

    passed ""
    passed "Sublime Text 3 installed successfully!"
    passed "Run with: subl"
    passed "\e[7m*** That's all. Have fun Sublime Texting ;)\e[0m"

} # end _fedora__64

_fedora__32() {
    execute_as_sudo
    local SUBLIMEDEVLASTESTBUILD=$(_version)
    local SUBLIMENAME="sublime_text_3_build_${SUBLIMEDEVLASTESTBUILD}_x32.tar.bz2"
    wait
    cd $USER_HOME/Downloads/
    download_sublime "${SUBLIMENAME}"
    wait

    if tar -xf "${SUBLIMENAME}" --directory=$USER_HOME; then
      sudo mv $USER_HOME/sublime_text/ /opt/
      sudo ln -s /opt/sublime_text/sublime_text /usr/bin/subl
    fi
    rm "${SUBLIMENAME}"

    download_install_package_control
    add_to_applications_list

    file_exists "
    /opt/sublime_text/sublime_text
    "

    softlink_exists "
    subl>/opt/sublime_text/sublime_text
    "
    wait
    passed ""
    passed "Sublime Text 3 installed successfully!"
    passed "Run with: subl"

} # end _fedora__32

_ubuntu__64() {
    execute_as_sudo
    local SUBLIMEDEVLASTESTBUILD=$(_version)
    echo " version ${SUBLIMEDEVLASTESTBUILD}"
    local SUBLIMENAME="sublime-text_build-${SUBLIMEDEVLASTESTBUILD}_amd64.deb"
    echo " looking for file ${SUBLIMENAME} online"
    wait
    echo "changing to Downloads folder  ~/Downloads/"
    cd ~/Downloads/
    echo "downloading ${SUBLIMENAME}"
    download_sublime "${SUBLIMENAME}"
    wait
    echo "installing "
    sudo dpkg -i ${SUBLIMENAME}
    wait
} # end _ubuntu__64

_linux__32() {
    execute_as_sudo
    local SUBLIMEDEVLASTESTBUILD=$(_version)
    local SUBLIMENAME="sublime-text_build-${SUBLIMEDEVLASTESTBUILD}_i386.deb"
    wait
    cd ~/Downloads/
    download_sublime "${SUBLIMENAME}"
    wait
    sudo dpkg -i ${SUBLIMENAME}
    wait
} # end _linux__32

_windows__64() {
    local SUBLIMEDEVLASTESTBUILD=$(curl -L https://www.sublimetext.com/3dev | sed -n "/<p\ class=\"latest\">/,/<\/div>/p" | head -1 | grep 'Build ....' | cut -c42-45)
    wait
    local SUBLIMENAME="Sublime%20Text%20Build%20${SUBLIMEDEVLASTESTBUILD}%20x64%20Setup.exe"
    wait
    cd $USER_HOMEDIR
    cd Downloads
    curl -O https://download.sublimetext.com/${SUBLIMENAME}
    ${SUBLIMENAME}
    wait
} # end _windows__64

_windows__32() {
    local SUBLIMEDEVLASTESTBUILD=$(curl -L https://www.sublimetext.com/3dev | sed -n "/<p\ class=\"latest\">/,/<\/div>/p" | head -1 | grep 'Build ....' | cut -c42-45)
    wait
    local SUBLIMENAME="Sublime%20Text%20Build%20${SUBLIMEDEVLASTESTBUILD}%20Setup.exe"
    wait
    cd $USER_HOMEDIR
    cd Downloads
    curl -O https://download.sublimetext.com/${SUBLIMENAME}
    ${SUBLIMENAME}
    wait
} # end _windows__32

determine_os_and_fire_action
