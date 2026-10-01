import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/utils/locale_keys.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';

class CustomScreenStateLayout extends StatelessWidget {
  final bool _isEmpty;
  final bool _isLoading;
  final ErrorModel? _error;
  final WidgetBuilder? _errorBuilder;
  final WidgetBuilder? _loadingBuilder;
  final VoidCallback? _onRetry;
  final WidgetBuilder _builder;
  final WidgetBuilder? _noDataBuilder;
  final Future<void> Function()? _onRefresh;
  const CustomScreenStateLayout({
    super.key,
    required WidgetBuilder builder,
    bool isEmpty = false,
    ErrorModel? error,
    bool isLoading = false,
    WidgetBuilder? errorBuilder,
    WidgetBuilder? loadingBuilder,
    WidgetBuilder? noDataBuilder,
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  })  : _isEmpty = isEmpty,
        _isLoading = isLoading,
        _error = error,
        _errorBuilder = errorBuilder,
        _loadingBuilder = loadingBuilder,
        _onRefresh = onRefresh,
        _noDataBuilder = noDataBuilder,
        _builder = builder,
        _onRetry = onRetry;

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }

  Widget _buildView(BuildContext context) {
    if (_isLoading) {
      return _loadingBuilder != null
          ? _loadingBuilder(context)
          : Center(
              child: CustomLoadingWidget(
              color: AppColors.primaryColor.themeColor,
              size: 40,
            ));
    } else if (_error != null) {
      return _errorBuilder != null
          ? _errorBuilder(context)
          : CustomErrorView(
              errorModel: _error,
              onRetry: _onRetry,
            );
    } else if (_isEmpty) {
      return _noDataBuilder != null
          ? _noDataBuilder(context)
          : CustomNoDataView(
              onRefresh: _onRefresh,
            );
    } else {
      if (_onRefresh != null) {
        return RefreshIndicator(
            onRefresh: _onRefresh, child: _builder(context));
      } else {
        return _builder(context);
      }
    }
  }
}

class CustomNoDataView extends StatelessWidget {
  final String? _title;
  final String? _desc;
  final String? _image;
  final String _imageSvg;
  final double _padding;
  final Future<void> Function()? _onRefresh;

  const CustomNoDataView({
    super.key,
    String? title,
    String? desc,
    String? image,
    double padding = 12,
    Future<void> Function()? onRefresh,
    String imageSvg = AppImages.noData,
  })  : _title = title,
        _padding = padding,
        _onRefresh = onRefresh,
        _desc = desc,
        _image = image,
        _imageSvg = imageSvg;
  @override
  Widget build(BuildContext context) {
    if (_onRefresh != null) {
      return RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(_padding.r),
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (_image != null)
                    ? Image.asset(_image)
                    : SvgPicture.asset(_imageSvg,
                        width: 200.w, height: 200.h, fit: BoxFit.fill),
                12.height,
                Text(_title ?? tr(LocaleKeys.error_notFound),
                    textAlign: TextAlign.center),
                12.height,
                Text(_desc ?? '', textAlign: TextAlign.center),
              ],
            )),
          ));
    } else {
      return Padding(
        padding: EdgeInsets.all(_padding.r),
        child: Center(
            child: FittedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (_image != null)
                  ? Image.asset(_image)
                  : SvgPicture.asset(_imageSvg,
                      width: 200.w, height: 200.h, fit: BoxFit.fill),
              12.height,
              Text(_title ?? tr(LocaleKeys.error_notFound),
                  textAlign: TextAlign.center),
              12.height,
              Text(_desc ?? '', textAlign: TextAlign.center),
            ],
          ),
        )),
      );
    }
  }
}

class CustomErrorView extends StatelessWidget {
  final ErrorModel? _errorModel;
  final VoidCallback? _onRetry;
  final String? _image;
  final String _imageSvg;

  const CustomErrorView({
    super.key,
    ErrorModel? errorModel,
    VoidCallback? onRetry,
    String? image,
    String imageSvg = AppImages.imagesErrorImage,
  })  : _errorModel = errorModel,
        _onRetry = onRetry,
        _image = image,
        _imageSvg = imageSvg;

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      message: _errorModel?.errorMessage ?? 'Error',
      onRetry: _onRetry,
      imageSvg: _imageSvg,
      image: _image,
    );
  }
}

class ErrorView extends StatelessWidget {
  final String? _message;
  final VoidCallback? _onRetry;
  final String? _image;
  final String _imageSvg;

  const ErrorView({
    super.key,
    String? message,
    VoidCallback? onRetry,
    String? image,
    String imageSvg = AppImages.imagesErrorImage,
  })  : _message = message,
        _onRetry = onRetry,
        _image = image,
        _imageSvg = imageSvg;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (_image != null)
                      ? Image.asset(_image)
                      : SvgPicture.asset(_imageSvg,
                          width: 200.w, height: 200.h, fit: BoxFit.fill),
                  AppText(
                    _message ?? '',
                    fontSize: 16,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  if (_onRetry != null)
                    TextButton(
                      onPressed: _onRetry,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Colors.grey)),
                      ),
                      child: Text(
                        tr(LocaleKeys.common_retry),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            )));
  }
}

class ErrorModel {
  final ErrorEnum code;
  final String errorMessage;
  final String? image;

  const ErrorModel({
    required this.code,
    required this.errorMessage,
    this.image,
  });

  @override
  String toString() {
    return 'ErrorModel{code: $code, errorMessage: $errorMessage, image: $image}';
  }
}

enum ErrorEnum {
  connectTimeout,

  sendTimeout,

  receiveTimeout,

  response,

  cancel,

  other,

  auth,
  server,
  verify,

  otherError
}
