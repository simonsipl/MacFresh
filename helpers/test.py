import os
import json
import npyscreen
import subprocess

class ProgramPicker(npyscreen.ActionForm):
    def create(self):
        self.programs = self._get_programs_from_file()
        self.checkboxes = [self.add(npyscreen.Checkbox, name=program) for program in self.programs]

    def _get_programs_from_file(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        json_file = os.path.join(dir_path, 'program_list.json')

        with open(json_file, 'r') as f:
            return json.load(f)['programs']

    def on_ok(self):
        selected_programs = self._get_selected_programs()
        if selected_programs:
            npyscreen.notify_confirm("You've selected: " + ", ".join(selected_programs) + ". Installation will start after you press OK.", title='Confirmation')
            self._install_programs(selected_programs)
            npyscreen.notify_confirm("Installation completed!", title='Confirmation')
        self.parentApp.setNextForm(None)

    def _get_selected_programs(self):
        return [self.programs[i].lower() for i, checkbox in enumerate(self.checkboxes) if checkbox.value]

    def _install_programs(self, selected_programs):
        for program in selected_programs:
            result = subprocess.run(['brew', 'install', program], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            if result.returncode != 0:
                npyscreen.notify_confirm("Installation of {} failed with error: \n {}".format(program, result.stderr.decode()), title='Error')
            else:
                self._handle_successful_installation(program, result.stdout.decode())

    def _handle_successful_installation(self, program, output_message):
        if "is already installed and up-to-date" in output_message:
            npyscreen.notify_confirm("{} is already installed and up-to-date".format(program), title='Confirmation')
        else:
            npyscreen.notify_confirm("{} has been installed or updated successfully".format(program), title='Confirmation')

    def on_cancel(self):
        npyscreen.notify_confirm("Installation cancelled!", title='Confirmation')
        self.parentApp.setNextForm(None)


class ProgramPickerApp(npyscreen.NPSAppManaged):
    def onStart(self):
        self.addForm('MAIN', ProgramPicker)


if __name__ == '__main__':
    ProgramPickerApp().run()