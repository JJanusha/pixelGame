import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:mobilegame/components/player.dart';
import 'package:mobilegame/components/level.dart';

class PixelGame extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection{
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  
  late final CameraComponent cam;
  Player player = Player(character: 'Ninja Frog');
  late JoystickComponent joystick;
  bool showjoystick = false;

@override
FutureOr<void> onLoad() async {
  // Cache image load
  await images.loadAllImages();

  final world = Level(levelName: 'Level-02', player: player);

  cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
  cam.viewfinder.anchor = Anchor.topLeft;

  addAll([cam, world]);

  if (showjoystick) {
    addJoystick();
  }

  return super.onLoad();
}


  @override
  void update(double dt) {
    if(showjoystick){
      updateJoystick();
    }
    super.update(dt);
  }
  
  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: EdgeInsets.only(left: 50, bottom: 50),
    );

    cam.viewport.add(joystick);
  }
  
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
  
}