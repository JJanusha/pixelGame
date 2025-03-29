import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:mobilegame/components/custom_hitbox.dart';
import 'package:mobilegame/pixel_game.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<PixelGame>, CollisionCallbacks {
  final String fruit;
  Fruit({this.fruit = 'Apple', position, size})
      : super(position: position, size: size);

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    priority = -1;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/$fruit.png'),
        SpriteAnimationData.sequenced(
            amount: 17, stepTime: stepTime, textureSize: Vector2.all(32)));
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;
      if (game.playSounds){
        FlameAudio.play('collect_fruit.wav', volume: game.soundVolume);
      }

    int points = 10; // Default points
    if (fruit == 'Cherries') points = 20;
    if (fruit == 'Bananas') points = 15;
    gameRef.score += points;
    // Add floating score effect
    // gameRef.add(FloatingScore(
    //   score: points,
    //   position: position + size / 2, // Center of the fruit
    // ));
        
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Fruits/Collected.png'),
          SpriteAnimationData.sequenced(
              amount: 6,
              stepTime: stepTime,
              textureSize: Vector2.all(32),
              loop: false));

      await animationTicker?.completed;
      removeFromParent();
    }
  }
}
