build_runner:
	fvm flutter pub run build_runner build -d delete-conflict
generate_app_icon:
	fvm dart run flutter_launcher_icons
rename_app_name:
	fvm dart rename_app:main 