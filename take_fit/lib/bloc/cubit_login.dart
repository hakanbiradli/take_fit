import 'package:flutter_bloc/flutter_bloc.dart';

// Checkbox'ın durumunu temsil eden enum
enum CheckboxState { checked, unchecked }

// Checkbox'ın durumunu yönetecek Cubit sınıfı
class CheckboxCubit extends Cubit<CheckboxState> {
  CheckboxCubit(bool initialValue)
      : super(initialValue ? CheckboxState.checked : CheckboxState.unchecked);

  void toggleCheckbox() {
    emit(state == CheckboxState.checked
        ? CheckboxState.unchecked
        : CheckboxState.checked);
  }
}
