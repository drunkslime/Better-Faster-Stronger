# Generated by Django 5.1.2 on 2024-12-27 13:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accessor', '0004_account_age_account_height_account_name_account_sex_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='account',
            name='workouts',
            field=models.JSONField(default=list),
        ),
    ]
