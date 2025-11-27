import 'package:app/core/utils/logger.dart';
import 'package:riverpod/riverpod.dart';

final class RiverpodLogObserver extends ProviderObserver {
  const RiverpodLogObserver();

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    super.didAddProvider(context, value);

    _log('add', context, value);
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    super.didUpdateProvider(context, previousValue, newValue);

    _log('update', context, newValue, previousValue);
  }

  void _log(
    String operation,
    ProviderObserverContext context,
    Object? value, [
    Object? previousValue,
  ]) {
    logger.debug('$operation $context.provider $value');
    if (context.provider.name != null) {
      logger.debug('#${context.provider} [$operation] $value');
      return;
    }

    if (value is AsyncError && value.hasError) {
      logger.error(
        '#${context.provider} [$operation]',
        error: value.error,
        stackTrace: value.stackTrace,
      );
    }
  }
}
