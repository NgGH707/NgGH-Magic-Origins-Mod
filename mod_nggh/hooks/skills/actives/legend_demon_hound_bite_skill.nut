::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_demon_hound_bite_skill", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Tear an enemy assunder with your cursed teeth. A bite can drain the stamina of your victim for 3 turns.";
		m.IconDisabled = "skills/demon_hound_bite_sw.png";
		m.SoundOnHitHitpoints = [
			"sounds/enemies/werewolf_claw_hit_01.wav",
			"sounds/enemies/werewolf_claw_hit_02.wav",
			"sounds/enemies/werewolf_claw_hit_03.wav"
		];
		m.InjuriesOnBody = ::Const.Injury.CuttingAndPiercingBody;
		m.InjuriesOnHead = ::Const.Injury.CuttingAndPiercingHead;
		m.ChanceDisembowel = 33;
	}

	q.getTooltip <- function()
	{
		return getDefaultTooltip();
	}
	
});