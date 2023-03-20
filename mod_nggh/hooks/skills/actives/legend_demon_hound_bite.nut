::mods_hookExactClass("skills/actives/legend_demon_hound_bite", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Tear an enemy assunder with your cursed teeth. A bite can drain the stamina of your victim for 3 turns.";
		this.m.IconDisabled = "skills/demon_hound_bite_sw.png";
		this.m.SoundOnHitHitpoints = [
			"sounds/enemies/werewolf_claw_hit_01.wav",
			"sounds/enemies/werewolf_claw_hit_02.wav",
			"sounds/enemies/werewolf_claw_hit_03.wav"
		];
		this.m.InjuriesOnBody = ::Const.Injury.CuttingAndPiercingBody;
		this.m.InjuriesOnHead = ::Const.Injury.CuttingAndPiercingHead;
		this.m.ChanceDisembowel = 33;
	};
	obj.getTooltip <- function()
	{
		return this.getDefaultTooltip();
	};
});