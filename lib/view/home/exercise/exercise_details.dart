import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseDetails extends StatefulWidget {
  final Map<String, dynamic> exerciseData;
  const ExerciseDetails({super.key, required this.exerciseData});



  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {

  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.asset(widget.exerciseData['video']);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: const EdgeInsets.all(30.0),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: <Widget>[
                      SafeArea(
                        child: Column(
                          children: [
                            Image(
                              fit: BoxFit.cover,
                              image: AssetImage('${widget.exerciseData['image']}')
                              ),
                            const SizedBox(height: 20),
                            Text(
                              semanticsLabel: 'Exercise: ${widget.exerciseData['name']}',
                              widget.exerciseData['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: const String.fromEnvironment('Poppins'),
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Type: ${widget.exerciseData['type']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: const String.fromEnvironment('Poppins'),
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                              )
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'Muscle Group: ${widget.exerciseData['group']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: const String.fromEnvironment('Poppins'),
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '\nEquipment: ${widget.exerciseData['equipment']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: const String.fromEnvironment('Poppins'),
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '\nLevel: ${widget.exerciseData['level']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: const String.fromEnvironment('Poppins'),
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '\nMechanics: ${widget.exerciseData['mechanics']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: const String.fromEnvironment('Poppins'),
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'Guide:\n ${widget.exerciseData['guide_text']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: const String.fromEnvironment('Poppins'),
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'Tips:\n ${widget.exerciseData['advices_text']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: const String.fromEnvironment('Poppins'),
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            IconButton.filled(
                                onPressed: 
                                () {
                                  _videoPlayerController.play();
                                  showDialog(
                                    context: context, 
                                    builder: (context) => Dialog.fullscreen(
                                      backgroundColor: theme.colorScheme.primaryContainer,
                                      child: FutureBuilder(
                                        future: _initializeVideoPlayerFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            return AspectRatio(
                                              aspectRatio: _videoPlayerController.value.aspectRatio,
                                              child: VideoPlayer(_videoPlayerController)
                                            );
                                          } else {
                                            return const Center(
                                              child: CircularProgressIndicator()
                                            );
                                          }
                                        }
                                      )
                                    ) 
                                  );
                                },
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: theme.colorScheme.onPrimaryContainer
                                ),
                                tooltip: 'Play Video',
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(theme.colorScheme.primaryContainer),
                                  shape: const WidgetStatePropertyAll<CircleBorder>(CircleBorder()),
                                ),
                            )
                          ],
                        )
                      ),
                  ],
                ),
              ),
            ),
          )
        );
      }
    );
  }
}