from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Exercise(models.Model):
    name = models.CharField(max_length=100)
    type = models.CharField(max_length=100)
    group = models.CharField(max_length=100)
    equipment = models.CharField(max_length=100)
    level = models.CharField(max_length=100)
    mechanics = models.CharField(max_length=100)
    guide_text = models.TextField()
    advices_text = models.TextField()
    image = models.CharField(max_length=100)
    video = models.CharField(max_length=100)

    class Meta:
        constraints = [
            models.CheckConstraint(
                condition=models.Q(
                    name__isnull=False),
                name='name_not_null'),

            models.CheckConstraint(
                condition=models.Q(
                    type__in=['Strength', 
                            'Warmup', 
                            'Cardio', 
                            'Finishing']), 
                name='type_check'),

            models.CheckConstraint(
                condition=models.Q(
                    group__in=['Abs',
                            'Back',
                            'Biceps',
                            'Chest',
                            'Forearms',
                            'Glutes',
                            'Shoulders',
                            'Triceps',
                            'Upper legs',
                            'Lower legs']), 
                name='group_check'),

            models.CheckConstraint(
                condition=models.Q(
                    equipment__in=['Bodyweight',
                                'Cable',
                                'Barbell',
                                'Bench',
                                'Dumbbell',
                                'Curl bar',
                                'Kettlebell',
                                'Machine']), 
                name='equipment_check'),

            models.CheckConstraint(
                condition=models.Q(
                    level__in=['Beginner', 
                            'Intermediate']), 
                name='level_check'),

            models.CheckConstraint(
                condition=models.Q(
                    mechanics__in=['Isolation', 
                                'Compound']), 
                name='mechanics_check'),

            models.CheckConstraint(
                condition=models.Q(
                    guide_text__isnull=False), 
                name='guide_text_not_null'),

            models.CheckConstraint(
                condition=models.Q(
                    advices_text__isnull=False), 
                name='advices_text_not_null'),

            # models.CheckConstraint(
            #     condition=models.Q(
            #         image__startswith='assets/img/'), 
            #     name='image_check'),

            # models.CheckConstraint(
            #     condition=models.Q(
            #         video__startswith='assets/raw/'), 
            #     name='video_check'),

        ]

    def __str__(self):
        return f'''{self.name}, 
                {self.type}, 
                {self.group}, 
                {self.equipment}, 
                {self.level}, 
                {self.mechanics}, 
                {self.guide_text}, 
                {self.advices_text}, 
                {self.image}, 
                {self.video}'''
    

class Account(models.Model):
    userRef = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100, null = True)
    sex = models.CharField(max_length=100, null = True)
    age = models.CharField(max_length=100, null = True)
    weight = models.CharField(max_length=100, null = True)
    height = models.CharField(max_length=100, null = True)
    


    def __str__(self):
        return f'''
                {self.userRef}
                '''