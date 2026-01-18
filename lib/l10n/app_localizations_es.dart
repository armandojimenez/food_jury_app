// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'FoodJury';

  @override
  String get appTagline => '¡Orden en la cocina!';

  @override
  String get common_ok => 'OK';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_delete => 'Eliminar';

  @override
  String get common_save => 'Guardar';

  @override
  String get common_yes => 'Sí';

  @override
  String get common_no => 'No';

  @override
  String get common_back => 'Atrás';

  @override
  String get common_close => 'Cerrar';

  @override
  String get greeting_morning => '¡Buenos días, hambriento!';

  @override
  String get greeting_afternoon => '¡Buenas tardes, hambriento!';

  @override
  String get greeting_evening => '¡Buenas noches, hambriento!';

  @override
  String get greeting_night => '¡Buenas noches, hambriento!';

  @override
  String get home_newDecision => 'Nueva Decisión';

  @override
  String get home_recentVerdicts => 'Veredictos Recientes';

  @override
  String get home_emptyTitle => 'Aún no hay veredictos...';

  @override
  String get home_emptyMessage =>
      '¡La corte está vacía! Es hora de presentar un caso.';

  @override
  String get home_emptyAction => 'Comenzar Tu Primer Caso';

  @override
  String get decision_screenTitle => '¿Cuál es el dilema?';

  @override
  String get decision_yourOptions => 'TUS OPCIONES';

  @override
  String get decision_addOption => 'Agregar Opción';

  @override
  String get decision_tapToAdd => 'Toca para agregar';

  @override
  String get decision_whatsYourGoal => '¿CUÁL ES TU OBJETIVO?';

  @override
  String get decision_letJudgeDecide => 'Que el Juez Decida';

  @override
  String get decision_minOptionsError =>
      'Agrega al menos 2 opciones para continuar';

  @override
  String get option_add => 'AGREGAR OPCIÓN';

  @override
  String get option_tapToAddPhoto => 'Toca para agregar foto';

  @override
  String get option_nameLabel => 'Nombre';

  @override
  String get option_nameHint => '¿Qué es?';

  @override
  String get option_notesLabel => 'Notas (opcional)';

  @override
  String get option_notesHint => '¿Algún detalle que el juez deba saber?';

  @override
  String get option_addToCase => 'Agregar al Caso';

  @override
  String get option_deleteConfirmTitle => '¿Eliminar Opción?';

  @override
  String get option_deleteConfirmMessage =>
      'Esto eliminará la opción de tu caso.';

  @override
  String get objective_fun => 'Diversión';

  @override
  String get objective_healthy => 'Saludable';

  @override
  String get objective_fit => 'Fit';

  @override
  String get objective_quick => 'Rápido';

  @override
  String get loading_courtInSession => 'La corte está en sesión...';

  @override
  String get loading_examiningEvidence => 'Examinando la evidencia...';

  @override
  String get loading_deliberating => 'Deliberando...';

  @override
  String get loading_almostThere => 'Casi listo...';

  @override
  String get verdict_theVerdictIsIn => 'EL VEREDICTO ESTÁ LISTO';

  @override
  String get verdict_winner => 'GANADOR';

  @override
  String get verdict_judgesNotes => 'Notas del Juez';

  @override
  String get verdict_seeAllRankings => 'Ver todas las clasificaciones';

  @override
  String get verdict_hideRankings => 'Ocultar clasificaciones';

  @override
  String get verdict_newDecision => 'Nueva Decisión';

  @override
  String get verdict_newCase => 'Nuevo Caso';

  @override
  String get verdict_share => 'Compartir';

  @override
  String get verdict_bonusJoke => 'Chiste del Juez';

  @override
  String get verdict_bonusFunFact => 'Dato Curioso';

  @override
  String get verdict_bonusTip => 'Consejo Pro';

  @override
  String get verdict_bonusStory => 'Historia';

  @override
  String get history_screenTitle => 'Veredictos Pasados';

  @override
  String get history_emptyTitle => 'Los registros de la corte están vacíos...';

  @override
  String get history_emptyMessage => '¡Aún no se han decidido casos!';

  @override
  String get history_today => 'Hoy';

  @override
  String get history_yesterday => 'Ayer';

  @override
  String get history_thisWeek => 'Esta Semana';

  @override
  String get history_deleteConfirmTitle => '¿Eliminar Decisión?';

  @override
  String get history_deleteConfirmMessage => 'Esto no se puede deshacer.';

  @override
  String get settings_screenTitle => 'Configuración';

  @override
  String get settings_judgePersonality => 'PERSONALIDAD DEL JUEZ';

  @override
  String get settings_appearance => 'APARIENCIA';

  @override
  String get settings_subscription => 'SUSCRIPCIÓN';

  @override
  String get settings_about => 'Acerca de';

  @override
  String get settings_privacy => 'Privacidad';

  @override
  String get settings_terms => 'Términos';

  @override
  String get settings_devSection => 'OPCIONES DE DESARROLLO';

  @override
  String get settings_useMockAi => 'Usar IA Simulada';

  @override
  String get settings_useMockAiDescription =>
      'Usar respuestas simuladas en lugar de llamadas reales a la IA';

  @override
  String get settings_mockAiEnabled => 'IA simulada activada';

  @override
  String get settings_mockAiDisabled => 'IA real activada';

  @override
  String get tone_stern => 'Serio y Justo';

  @override
  String get tone_sternPreview => 'La corte determina...';

  @override
  String get tone_sassy => 'Atrevido';

  @override
  String get tone_sassyPreview => 'Escucha, he visto...';

  @override
  String get tone_enthusiastic => 'Entusiasta';

  @override
  String get tone_enthusiasticPreview => '¡OH WOW! Esto es...';

  @override
  String get tone_chill => 'Relajado';

  @override
  String get tone_chillPreview => 'Entonces, mira...';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_dark => 'Oscuro';

  @override
  String get theme_system => 'Auto';

  @override
  String get subscription_pro => 'FoodJury Pro';

  @override
  String get subscription_unlimitedDecisions => 'Decisiones ilimitadas';

  @override
  String get subscription_upgradeNow => 'Mejorar Ahora';

  @override
  String get error_noInternet => 'La corte está fuera de línea...';

  @override
  String get error_noInternetMessage =>
      '¡Despiértame cuando volvamos a estar en línea!';

  @override
  String get error_tryAgain => 'Intentar de Nuevo';

  @override
  String get error_genericTitle => '¡Oops!';

  @override
  String get error_genericMessage =>
      'Algo salió mal. Por favor, inténtalo de nuevo.';

  @override
  String get onboarding_skip => 'Omitir';

  @override
  String get onboarding_next => 'Siguiente';

  @override
  String get onboarding_getStarted => 'Comenzar';

  @override
  String get onboarding_welcome_title => 'Conoce a Judge Bite';

  @override
  String get onboarding_welcome_message =>
      '¡Tu juez personal de comida que te ayuda a tomar decisiones deliciosas!';

  @override
  String get onboarding_howItWorks_title => 'Cómo Funciona';

  @override
  String get onboarding_howItWorks_message =>
      '¡Agrega tus opciones de comida, establece tu objetivo y deja que el juez entregue el veredicto!';

  @override
  String get onboarding_personality_title => 'Elige Tu Estilo';

  @override
  String get onboarding_personality_message =>
      'Elige cómo Judge Bite debe entregar los veredictos. ¡Puedes cambiar esto en cualquier momento!';

  @override
  String get snackbar_decisionSaved => '¡Decisión registrada!';

  @override
  String get snackbar_optionAdded => 'Opción agregada al caso';

  @override
  String get snackbar_optionDeleted => 'Opción eliminada';

  @override
  String get snackbar_decisionDeleted => 'Decisión eliminada';

  @override
  String get image_addPhoto => 'Agregar Foto';

  @override
  String get image_changePhoto => 'Cambiar Foto';

  @override
  String get image_removePhoto => 'Eliminar Foto';

  @override
  String get image_takePhoto => 'Tomar Foto';

  @override
  String get image_chooseFromGallery => 'Elegir de Galería';

  @override
  String get image_photoEvidence => 'Evidencia Fotográfica';

  @override
  String get permission_cameraTitle => 'Acceso a Cámara Necesario';

  @override
  String get permission_cameraMessage =>
      'Por favor permite acceso a la cámara para tomar fotos de tus opciones de comida.';

  @override
  String get permission_galleryTitle => 'Acceso a Fotos Necesario';

  @override
  String get permission_galleryMessage =>
      'Por favor permite acceso a la galería para seleccionar fotos de tus opciones de comida.';

  @override
  String get permission_deniedTitle => 'Permiso Denegado';

  @override
  String get permission_deniedMessage =>
      'Sin este permiso, no puedes agregar fotos. Puedes habilitarlo en Configuración.';

  @override
  String get permission_openSettings => 'Abrir Configuración';

  @override
  String get error_imageLoad => 'Error al cargar imagen';

  @override
  String get snackbar_photoAdded => '¡Evidencia fotográfica agregada!';

  @override
  String get snackbar_photoRemoved => 'Foto eliminada';

  @override
  String get common_loading => 'Cargando...';

  @override
  String get decision_addOptionsToBegin =>
      'Agrega tus opciones de comida para comenzar';

  @override
  String decision_addMoreOptions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'es',
      one: '',
    );
    return 'Agrega $count opción$_temp0 más';
  }

  @override
  String get decision_pickYourGoal => '¡Ahora elige tu objetivo!';

  @override
  String get decision_readyForVerdict => '¡Listo para el veredicto!';

  @override
  String get decision_noEvidenceYet => '¡Aún no hay evidencia!';

  @override
  String get decision_addOptionsToBuildCase =>
      'Agrega tus opciones de comida para construir tu caso';

  @override
  String get decision_addFirstOption => 'Agregar Primera Opción';

  @override
  String get decision_addToYourCase => 'Agregar a tu caso';

  @override
  String decision_slotsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count restante$_temp0';
  }

  @override
  String get validation_pleaseEnterName => 'Por favor ingresa un nombre';

  @override
  String get judgeBite_presentEvidence => '¡Presenta tu evidencia!';

  @override
  String get judgeBite_addMoreToCompare =>
      '¿Una opción? ¡Agrega más para comparar!';

  @override
  String get judgeBite_tellMeYourGoal => '¡Ahora dime tu objetivo!';

  @override
  String get judgeBite_readyToDeliver => '¡Listo para entregar el veredicto!';

  @override
  String get judgeBite_buildingCase => 'Construyendo un caso sólido...';

  @override
  String a11y_removeOption(String name) {
    return 'Eliminar $name';
  }

  @override
  String a11y_photoOf(String name) {
    return 'Foto de $name';
  }
}
