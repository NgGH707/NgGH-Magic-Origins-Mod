::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/legend_hidden_effect", function(q) 
{
	q.onAdded = @(__original) function()
	{
		local actor = getContainer().getActor();

		if (!actor.getFlags().has("human")) {
			if (actor.getTile().IsVisibleForPlayer) {
				for( local i = 0; i < ::Const.Tactical.HideParticles.len(); ++i )
				{
					::Tactical.spawnParticleEffect(false, ::Const.Tactical.HideParticles[i].Brushes, actor.getTile(), ::Const.Tactical.HideParticles[i].Delay, ::Const.Tactical.HideParticles[i].Quantity, ::Const.Tactical.HideParticles[i].LifeTimeQuantity, ::Const.Tactical.HideParticles[i].SpawnRate, ::Const.Tactical.HideParticles[i].Stages);
				}
			}

			actor.setBrushAlpha(10);
			actor.setHidden(true);
			actor.setDirty(true);
			return;
		}

		__original();
	}

	q.onRemoved = @(__original) function()
	{
		local actor = getContainer().getActor();

		if (!actor.getFlags().has("human")) {
			actor.setHidden(false);
			actor.setBrushAlpha(255);

			foreach (i in actor.getItems().getAllItems())
				i.updateAppearance();

			if (actor.getTile().IsVisibleForPlayer) {
				for( local i = 0; i < ::Const.Tactical.HideParticles.len(); ++i )
				{
					::Tactical.spawnParticleEffect(false, ::Const.Tactical.HideParticles[i].Brushes, actor.getTile(), ::Const.Tactical.HideParticles[i].Delay, ::Const.Tactical.HideParticles[i].Quantity, ::Const.Tactical.HideParticles[i].LifeTimeQuantity, ::Const.Tactical.HideParticles[i].SpawnRate, ::Const.Tactical.HideParticles[i].Stages);
				}
			}
			return;
		}

		__original();
	}

	q.onUpdate = @(__original) function( _properties )
	{
		local actor = getContainer().getActor();

		if (!actor.getFlags().has("human")) {
			if (actor.getSkills().hasSkill("perk.legend_assassinate")) {
				_properties.DamageRegularMin *= 1.5;
				_properties.DamageRegularMax *= 1.5;

				if (actor.getSkills().hasSkill("background.legend_assassin") || actor.getSkills().hasSkill("background.assassin") || actor.getSkills().hasSkill("background.assassin_southern"))
					_properties.DamageRegularMax *= 1.5;
				if (actor.getSkills().hasSkill("bbackground.legend_commander_assassin"))
					_properties.DamageRegularMax *= 2.0;
			}

			_properties.TargetAttractionMult *= 0.5;
			actor.setBrushAlpha(10);
			actor.setHidden(true);
			return;
		}

		__original(_properties);
	}
});