import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

enum Bot82AvatarState { normal, thinking, error }

class Bot82Avatar extends StatefulWidget {
  final Bot82AvatarState state;
  final double radius;

  const Bot82Avatar({
    super.key,
    this.state = Bot82AvatarState.normal,
    this.radius = 16.0,
  });

  @override
  State<Bot82Avatar> createState() => _Bot82AvatarState();
}

class _Bot82AvatarState extends State<Bot82Avatar> with TickerProviderStateMixin {
  late AnimationController _morphController;
  late Animation<double> _numberAnim;
  late AnimationController _pulseController;
  late AnimationController _glitchController;
  
  int _currentNumber = 41;
  bool _morphed = false;

  @override
  void initState() {
    super.initState();
    
    // Slot machine morphing from 41 to 82
    _morphController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _numberAnim = Tween<double>(begin: 41, end: 82).animate(
      CurvedAnimation(parent: _morphController, curve: Curves.easeOutExpo)
    );
    
    _numberAnim.addListener(() {
      setState(() {
        _currentNumber = _numberAnim.value.round();
      });
    });
    
    _morphController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _morphed = true;
        });
      }
    });
    
    _morphController.forward();

    // Pulse animation for thinking state
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      } else if (status == AnimationStatus.dismissed && widget.state == Bot82AvatarState.thinking) {
        _pulseController.forward();
      }
    });

    // Glitch animation for error state
    _glitchController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _glitchController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _glitchController.reverse();
      } else if (status == AnimationStatus.dismissed && widget.state == Bot82AvatarState.error) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && widget.state == Bot82AvatarState.error) _glitchController.forward();
        });
      }
    });
  }

  @override
  void didUpdateWidget(Bot82Avatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      if (widget.state == Bot82AvatarState.thinking) {
        _pulseController.forward();
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
      
      if (widget.state == Bot82AvatarState.error) {
        _glitchController.forward();
      } else {
        _glitchController.stop();
        _glitchController.reset();
      }
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    _pulseController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final neonOrange = const Color(0xFFFF6F00);
    
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _glitchController, _morphController]),
      builder: (context, child) {
        double pulseScale = 1.0 + (_pulseController.value * 0.15);
        double pulseOpacity = 1.0 - (_pulseController.value * 0.3);
        
        double glitchX = widget.state == Bot82AvatarState.error ? (math.Random().nextDouble() - 0.5) * 4 * _glitchController.value : 0;
        double glitchY = widget.state == Bot82AvatarState.error ? (math.Random().nextDouble() - 0.5) * 4 * _glitchController.value : 0;
        
        return Transform.translate(
          offset: Offset(glitchX, glitchY),
          child: Transform.scale(
            scale: widget.state == Bot82AvatarState.thinking ? pulseScale : 1.0,
            child: Container(
              width: widget.radius * 2,
              height: widget.radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/images/bot82_full.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: widget.state == Bot82AvatarState.thinking ? [
                  BoxShadow(
                    color: neonOrange.withOpacity(_pulseController.value * 0.6),
                    blurRadius: 12 * _pulseController.value,
                    spreadRadius: 2 * _pulseController.value,
                  )
                ] : widget.state == Bot82AvatarState.error ? [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(_glitchController.value),
                    blurRadius: 10,
                    offset: Offset(glitchX, glitchY),
                  )
                ] : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
