import 'package:flutter/material.dart';

class CardSliverAppBar extends StatefulWidget {
  final double height;
  final Image background;
  final double appBarHeight = 60;
  final Text title;
  final Text? titleDescription;
  final bool backButton;
  final List<Color>? backButtonColors;
  final Widget? action;
  final Widget body;
  final ImageProvider? card;

  const CardSliverAppBar(
      {Key? key,
      required this.height,
      required this.background,
      required this.title,
      required this.body,
      this.titleDescription,
      this.backButton = false,
      this.backButtonColors,
      this.action,
      this.card})
      : super(key: key);

  @override
  State<CardSliverAppBar> createState() => _CardSliverAppBarState();
}

class _CardSliverAppBarState extends State<CardSliverAppBar> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _fadeTransition;
  late Animatable<Color> _animateBackButtonColors;
  late Animation<double> _rotateCard;

  double _scale = 0.0;
  double _offset = 0.0;

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    _fadeTransition = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    )..addListener(() {
        setState(() {});
      });

    if (widget.card != null) {
      _rotateCard = Tween(begin: 0.0, end: 0.4).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear))
        ..addListener(() {
          setState(() {});
        });
    }

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
  }

  void _animationValue(double scale){
    _animationController.value = scale;
  }

  // gets

  get _backButtonColors => widget.backButtonColors;
  get _cart => widget.card;
  get _action => widget.action;
  get _backButton => widget.backButton;
  get _height => widget.height;
  get _body => widget.body;
  get _appBarHeight => widget.appBarHeight;
  get _background => widget.background;
  get _titleDescription => widget.titleDescription;
  get _title => widget.title;

  @override
  Widget build(BuildContext context) {

    if(_scrollController.hasClients){
      _scale = _scrollController.offset / (widget.height - widget.appBarHeight);

      if(_scale > 1){
        _scale = 1.0;
      }
      _offset = _scrollController.offset;
    }

    _animationValue(_scale);
    _scale = 1.0 - _scale;

    if(_backButtonColors != null && _backButtonColors.length >= 2){
      _animateBackButtonColors = TweenSequence<Color>([
        TweenSequenceItem(
            weight: 1.0,
            tween: ColorTween(
          begin: _backButtonColors[0],
          end: _backButtonColors[1],
        ))
      ]);
    }

    return Container();
  }
}
