Name: harbour-fremantleline
Version: 0.7
Release: 0.1
Summary: Perth trains live departure information
URL: http://www.perthtrains.net/
License: GPLv3
Source: https://github.com/mattaustin/fremantleline/archive/development.tar.gz
BuildArch: noarch
Requires: libsailfishapp-launcher
Requires: python3-base
Requires: pyotherside-qml-plugin-python3-qt5
Requires: sailfishsilica-qt5


%description
Live departure information for Perth metropolitan train services. View the
service information by station, including: direction, stopping pattern, and
number of cars.


%prep
%setup -q -n fremantleline-development


%install
rm -rf %{buildroot}

# Application files
TARGET=%{buildroot}/%{_datadir}/%{name}
mkdir -p $TARGET
cp -rpv fremantleline $TARGET/
cp -rpv qml/sailfishos $TARGET/qml
ln -s main.qml $TARGET/qml/%{name}.qml

# Desktop Entry
TARGET=%{buildroot}/%{_datadir}/applications
mkdir -p $TARGET
cp -rpv %{name}.desktop $TARGET/

# Icon
TARGET=%{buildroot}/%{_datadir}/icons/hicolor/86x86/apps/
mkdir -p $TARGET
cp -rpv icons/sailfishos.png $TARGET/%{name}.png


%files
%doc README.rst COPYING
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
