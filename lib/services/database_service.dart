import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class DatabaseService {
    static Database? _db;
    static final DatabaseService instance = DatabaseService._constructor();

    TableExercises tableExercises = TableExercises._init();

    DatabaseService._constructor();

    Future<Database> get database async {
        if (_db != null) return _db!;
        _db = await getDatabase();
        return _db!;
    }

    Future<Database> getDatabase() async {
        final databaseDirPath = await getDatabasesPath();
        final databasePath = join(databaseDirPath, 'better_faster_stronger.db');
        final database = await openDatabase(
            databasePath,
            version: 1,
            onOpen: (db) => logger.d("Database opened at $databasePath"),
            onCreate: (db, version) {
                return db.execute('''
            CREATE TABLE ${tableExercises._tableName} (
                ${tableExercises._idColumn} INTEGER PRIMARY KEY ASC ON CONFLICT ROLLBACK AUTOINCREMENT NOT NULL,
                ${tableExercises._nameColumn} TEXT DEFAULT ('EXERCISE_NAME') NOT NULL,
                ${tableExercises._typeColumn} TEXT CHECK (
                    ${tableExercises._typeColumn} IN ('Strength', 'Warmup', 'Cardio', 'Finishing')
                ) NOT NULL,
                ${tableExercises._groupColumn} TEXT NOT NULL CHECK (
                    ${tableExercises._groupColumn} IN (
                        'Abs',
                        'Back',
                        'Biceps',
                        'Chest',
                        'Forearms',
                        'Glutes',
                        'Shoulders',
                        'Triceps',
                        'Upper legs',
                        'Lower legs'
                    )
                ),
                ${tableExercises._equipmentColumn} TEXT NOT NULL CHECK (
                    ${tableExercises._equipmentColumn} IN (
                        'Bodyweight',
                        'Cable',
                        'Barbell',
                        'Bench',
                        'Dumbbell',
                        'Curl bar',
                        'Kettlebell',
                        'Machine'
                    )
                ),
                ${tableExercises._levelColumn} TEXT NOT NULL CHECK (${tableExercises._levelColumn} IN ('Beginner', 'Intermediate')),
                ${tableExercises._mechanicsColumn} TEXT CHECK (${tableExercises._mechanicsColumn} IN ('Isolation', 'Compound')) NOT NULL,
                ${tableExercises._guideColumn} TEXT NOT NULL DEFAULT ('EXERCISE_GUIDE'),
                ${tableExercises._tipsColumn} TEXT DEFAULT ('EXERCISE_TIPS') NOT NULL,
                ${tableExercises._imageColumn} TEXT DEFAULT ('EXERCISE_IMAGE') NOT NULL CHECK (${tableExercises._imageColumn} LIKE '/assets/%'),
                ${tableExercises._videoColumn} TEXT DEFAULT ('EXERCISE_VIDEO') NOT NULL CHECK (${tableExercises._videoColumn} LIKE '/assets/%')
            );   
            ''');
            },
        );
        return database;
    }
    
    // void setUpDatabase() async {
    //     final db = await database;
    //     for () {

    //     }
    // }


    void addRegister(String name, String guide) async {
        final db = await database;
        await db.insert(tableExercises._tableName, {
            tableExercises._nameColumn: name,
            tableExercises._typeColumn: 'Strength',
            tableExercises._groupColumn: 'Abs',
            tableExercises._equipmentColumn: 'Bodyweight',
            tableExercises._levelColumn: 'Beginner',
            tableExercises._mechanicsColumn: 'Isolation',
            tableExercises._guideColumn: guide,
            tableExercises._tipsColumn: 'EXERCISE_TIPS',
            tableExercises._imageColumn: '/assets/img/plank-image.jpg',
            tableExercises._videoColumn: '/assets/raw/Plank.mp4'
        });
    }
}

class TableExercises {
    final String _tableName = 'exercises';
    final String _idColumn = 'id';
    final String _nameColumn = 'exercise_name';
    final String _typeColumn = 'exercise_type';
    final String _groupColumn = 'exercise_group';
    final String _equipmentColumn = 'exercise_equipment';
    final String _levelColumn = 'exercise_level';
    final String _mechanicsColumn = 'exercise_mechanics';
    final String _guideColumn = 'exercise_guide';
    final String _tipsColumn = 'exercise_tips';
    final String _imageColumn = 'exercise_image';
    final String _videoColumn = 'exercise_video';

    late List<Map<String, Object>> entries;

    tableEntries() {
      entries = [
        {
          _idColumn: 'DEFAULT',
          _nameColumn: 'Plank',
          _typeColumn: 'Strength',
          _groupColumn: 'Abs',
          _equipmentColumn: 'Bodyweight',
          _levelColumn: 'Beginner',
          _mechanicsColumn: 'Isolation',
          _guideColumn: '''1. The Plank is a stationary exercise that helps strengthen the entire core of the body. Set up for the plank by getting a mat and laying down on your stomach.
              2. To start the exercise prop your torso up on your elbows and your feet up on your toes.
              3. Keeping yourself completely straight, hold this position for as long as possible.
              4. Typically, the plank is done for 3 x 1 minute sets. However, as you get stronger your should be able to do 1 - 3 minutes.''',
          _tipsColumn: '''1. Do not let your mid section sag in the middle. You need to keep yourself straight at all times.
              2. Do this exercise in front of a mirror to make sure you are not letting your technique slip.
              3. Raise an arm or a leg to increase intensity.''',
          _imageColumn: '/assets/img/plank.jpg',
          _videoColumn: '/assets/raw/plank.mp4'
        },

        {
          _idColumn: 'DEFAULT',
        _nameColumn: 'Seated Cable Row',
        _typeColumn: 'Strength',
        _groupColumn: 'Back',
        _equipmentColumn: 'Cable',
        _levelColumn: 'Beginner',
        _mechanicsColumn: 'Compound',
        _guideColumn: '''1. Set the appropriate weight on the weight stack and attach a close-grip bar or V-bar to the seated row machine.
            2. Grasp the bar with a neutral grip (palms facing in).
            3. Keeping your legs slightly bent and your back straight, pull the weight up slightly off the stack. You should be sitting straight upright with your shoulders back. This is the starting position.
            4. Keeping your body in position, pull the handle into your stomach.
            5. Pull your shoulder blades back, squeeze, pause, and then slowly lower the weight back to the starting position.
            6. Repeat for desired reps.''',
        _tipsColumn: '''1. Your back must remain straight at all times. Your torso should be kept still throughout the entire set.
            2. Don't let your shoulders hunch over when your arms are extended.
            3. Use the back muscles to move the weight - do not lean forward and use momentum to swing the weight back.
            4.Pausing and squeezing at the top of the movement for a 1-2 count will increase intensity and results.''',
        _imageColumn: '/assets/img/machinerow.jpg',
        _videoColumn: '/assets/raw/machinerow.mp4'
        },

        {
          _idColumn: 'DEFAULT',
        _nameColumn: 'Reverse Grip Bent Over Row',
        _typeColumn: 'Strength',
        _groupColumn: 'Back',
        _equipmentColumn: 'Barbell',
        _levelColumn: 'Intermediate',
        _mechanicsColumn: 'Compound',
        _guideColumn: '''1. Grab a barbell, load some weight on, and place the barbell down in front of you.
            2. Stand with your feet at around shoulder width, bend at the knees, squat down to grip the bar with a reverse grip (thumbs at the top of the bar) and your hands wider than shoulder width apart.
            3. Keeping your back straight, stand straight up so you're holding the bar in front of you against your waist.
            4. To get into the starting position bend you knees slightly, and while keeping your back straight let the barbell slide down your thighs until it drops just below knee level. This is the stance that should not change throughout the set.
            5. Now pull the bar up to just below your chest.
            6. Squeeze your shoulder blades together at the top of the movement.
            7. Then slowly lower the bar back to the starting position. Repeat for desired reps.''',
        _tipsColumn: '''1. Pause at the top of the exercise and squeeze your shoulder blades together.
            2. Don't let the weight drop down quickly - keep it slow.
            3. Keep your back straight throughout the entire set.
            4. Keep your head up and your eyes looking forward throughout the whole movement.
            5.The bent over row can cause back injuries, so make sure your technique is perfected before loading on the weight.''',
        _imageColumn: '/assets/img/reversegripbentoverrow.jpg',
        _videoColumn: '/assets/raw/reversegripbentoverrow.mp4'
        },

        {
          _idColumn: 'DEFAULT',
        _nameColumn: 'Seated High Cable Row',
        _typeColumn: 'Strength',
        _groupColumn: 'Back',
        _equipmentColumn: 'Cable',
        _levelColumn: 'Beginner',
        _mechanicsColumn: 'Compound',
        _guideColumn: '''1. The high seated row is a great exercise for hitting the upper back and traps. Grab a flat bench and position it in front of a cable machine.
            2. Attach a rope extension to the low pulley cable and select the weight you want to use on the stack.
            3. Sit down on the bench facing the cable machine with your feet and knees together.
            4. Grasp the rope extension from below with a neutral grip (thumbs facing inwards).
            5. Sit straight up with your shoulders back and arms fully extended. This is the starting position.
            6. Slowly pull the rope up towards your upper chest.
            7.At the top of the movement, part the rope so that your hands are almost touching your shoulders.
            8. Pause, and then slowly lower the weight back to the starting position.''',
        _tipsColumn: '''1. Squeeze your shoulders together at the top of the movement.
            2. Only your arms should move in this exercise. Focus on keeping the rest of your body as still as possible.''',
        _imageColumn: '/assets/img/seatedhighcablerow.jpg',
        _videoColumn: '/assets/raw/seatedhighcablerow.mp4'
        },

        {
          _idColumn: 'DEFAULT',
        _nameColumn: 'Machine Lateral Raise',
        _typeColumn: 'Strength',
        _groupColumn: 'Shoulders',
        _equipmentColumn: 'Machine',
        _levelColumn: 'Beginner',
        _mechanicsColumn: 'Isolation',
        _guideColumn: '''1. Begin by selecting the weight you wish to use on the stack of a lateral raise machine.
            2. Adjust the seat height and sit facing the machine with your feet flat on the floor around shoulder width apart.
            3. Secure your arms in the padding and grip the handles. Look straight ahead. You are now ready to begin the exercise.
            4. With a bend in the elbows and moving only at the shoulders, begin pushing the weight up until your forearms are just above parallel.
            5. Contract your shoulders at the height of the movement and begin slowly lowering the weight using the same semicircle motion you used raise it.
            6. Repeat this movement for desired reps.''',
        _tipsColumn: '''1. As this is an isolation movement, form is more important that weight.
            2. Keep the delts under strain by using strict form.
            3. Use a full range of motion.
            4. Keep your body as still as possible throughout the movement, moving only at the shoulders.''',
        _imageColumn: '/assets/img/machinelateralraise.jpg',
        _videoColumn: '/assets/raw/machinelateralraise.mp4'
        },

        {
          _idColumn: 'DEFAULT',
        _nameColumn: 'Clean Press',
        _typeColumn: 'Strength',
        _groupColumn: 'Shoulders',
        _equipmentColumn: 'Barbell',
        _levelColumn: 'Intermediate',
        _mechanicsColumn: 'Compound',
        _guideColumn: '''1. Begin the clean and press by placing a barbell on the floor in front of you and standing with your shoulders around shoulder width apart.
            2. After loading the appropriate weight, make sure the bar is positioned over the tops of your feet at the mid-way point (half way between your toes and heel).
            3. From this position, bend down and grasp the bar with an overhand grip.
            4. Lower your buttocks to the ground until your thighs are parallel to the ground. Make sure your knees do NOT track out over your toes when doing so.
            5. Look straight ahead and keep your back straight - make sure there is no arch in your lower back. You are now ready to begin the exercise.
            6. Explode upward through your legs and quickly snap the weight up to your chest level in one fluid movement.
            7. Continue the movement by pushing the weight straight above your head, using your shoulders and triceps to move the weight.
            8. Under strict control, lower the weight back to your chest and then back to the floor in the same fashion.
            9. Repeat for desired reps.''',
        _tipsColumn: '''1. To avoid injury, correct form is paramount with this exercise! Practice good form before loading on the weight.
            2. Never arch your lower back! Any arch in the lower back is asking for injury.
            3.Lower the weight if you find that you are being pulled too far backwards when performing the clean and press.''',
        _imageColumn: '/assets/img/cleanpress.jpg',
        _videoColumn:'/assets/raw/cleanpress.mp4'
        },

        {
          _idColumn: 'DEFAULT',
        _nameColumn: 'Smith Machine Shoulder Press Behind Neck',
        _typeColumn: 'Strength',
        _groupColumn: 'Shoulders',
        _equipmentColumn: 'Machine',
        _levelColumn: 'Intermediate',
        _mechanicsColumn: 'Compound',
        _guideColumn: '''1. Set up for the smith machine shoulder press behind the neck by setting a bench down in the smith machine and adjusting the back to a 90-degree angle.
            2. Sit down on the bench and adjust the position so that the bar comfortably comes down just behind your head.
            3. Add the weight you want to use and sit down on the bench.
            4. Un-rack the weights and bend your elbows slightly. This is the starting position for the movement.
            5. Slowly begin lowering the bar down behind your neck as far as comfortably possible.
            6. Once your upper arms are slightly past parallel to the floor, pause, and then slowly raise the barbell back up without locking the elbows out at the top of the movement.
            7. Repeat for desired reps.''',
        _tipsColumn: '''1. To help avoid injury, do not lower the bar much further than the top of your head when bringing the bar down behind you. This will keep your arms at a 90-degree angle to the floor and place less stress on your shoulder joints.
            2. Keep your back straight throughout the movement. Don't let it arc too much when pressing the weight.
            3. Use a lighter weight than you would on a regular barbell press.
            4. Use slow and controlled movement, both when pressing and when lowering the weight.''',
        _imageColumn: '/assets/img/smithmachineshoulderpressbehindneck.jpg',
        _videoColumn: '/assets/raw/smithmachineshoulderpressbehindneck.mp4'
        },

        {
          _idColumn: 'DEFAULT',
        _nameColumn: 'Barbell Bench Press',
        _typeColumn: 'Strength',
        _groupColumn: 'Chest',
        _equipmentColumn: 'Barbell',
        _levelColumn: 'Intermediate',
        _mechanicsColumn: 'Compound',
        _guideColumn: '''1. Lie flat on a bench and set your hands just outside of shoulder width.
            2. Set your shoulder blades by pinching them together and driving them into the bench.
            3. Take a deep breath and allow your spotter to help you with the lift off in order to maintain tightness through your upper back.
            4. Let the weight settle and ensure your upper back remains tight after lift off.
            5. Inhale and allow the bar to descend slowly by unlocking the elbows.
            6. Lower the bar in a straight line to the base of the sternum (breastbone) and touch the chest.
            7. Push the bar back up in a straight line by pressing yourself into the bench, driving your feet into the floor for leg drive, and extending the elbows.
            8. Repeat for the desired number of repetitions.''',
        _tipsColumn: '''1. Technique first, weight second - no one cares how much you bench if you get injured.
            2. Keep the bar in line with your wrist and elbows and ensure it travels in a straight line. In order to keep the wrist straight, try to position the bar as low in the palm as possible while still being able to wrap the thumb.
            3. If you want to keep more tension through the triceps and chest, stop each repetition just short of lockout at the top.
            4. Don’t worry about tucking the elbows excessively, much of this advice is from geared lifters using suits. A slight tuck on the way down may be advisable for some lifters but other lifters can use an excellent cue from Greg Nuckols that will accomplish the same thing: “Flare and push”.
            5. Arching may be advisable depending upon your goals but ensure that most of the arch comes from the mid to upper back and not your lower back. If your lower back is cramping as you set up for the lift, you’re out of position and putting yourself at risk for potential injury.
            6. The bar should touch your chest with every single repetition. If you want to overload specific ranges of motion, look into board presses or accommodating resistance with chains or bands.
            7. As the bar descends, aim for your sternum (breastbone) or slightly below depending upon the length of your upper arm in order to promote a linear bar path.
            8. Intermediate and advanced lifters may use a thumbless or “suicide” grip but for the majority of lifters, it would be wiser to learn how to bench with the thumb wrapped around the bar at first.
            9. Fight to the urge to allow the wrists to roll back into extension, think about rolling your knuckles toward the ceiling.
            10. Experiment with grip width - if your have longer arms you may need to use a slightly wider grip. However, if you’re feeling pressure in the front of the shoulder during the exercise, you may need to widen your grip, improve scapular retraction, or slightly lessen the range of motion via exercises such as floor or board presses.
            11. Squeeze the bar as tightly as possible to help enhance shoulder stability.
            12. Some lifters prefer to tuck their toes while other prefer to keep the feet flat in order to optimize leg drive - experiment with both and see which one feels and allows for greater power production.
            13. Ensure the shoulder blades remain retracted and don’t allow them to change position as you press.
            14. The bar should descend under control and touch the lifter’s chest - no bouncing or excess momentum.
            15. Think about trying to push yourself away from the bar instead of pushing the bar off of you.
            16. Tightness through the upper back should be one of your main priorities throughout the course of the lift.
            17. Ideally, use a spotter to help assist with the lift off in order to maintain tension through the upper back.
            18. Keep the feet quiet throughout the lift and utilize leg drive by pushing your feet into the floor and squeezing your glutes to stabilize the pelvis.
            19. Focus on pulling the bar apart or trying to “bend the bar” in order to activate some of the intrinsic stabilizers in the shoulder.
            20. The glutes and shoulder blades should maintain contact with the bench throughout the entirety of the movement.''',
        _imageColumn: '/assets/img/barbellbenchpress.jpg',
        _videoColumn: '/assets/raw/barbellbenchpress.mp4'
        }
      ];  
    }

    TableExercises._init();
}
