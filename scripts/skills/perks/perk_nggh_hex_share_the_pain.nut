this.perk_nggh_hex_share_the_pain <- ::inherit("scripts/skills/skill", {
	m = {
		TempHex = null,
		ChosenTarget = [],
	},
	function create()
	{
		this.m.ID = "perk.hex_share_the_pain";
		this.m.Name = ::Const.Strings.PerkName.NggHHexSharePain;
		this.m.Description = ::Const.Strings.PerkDescription.NggHHexSharePain;
		this.m.Icon = "ui/perks/perk_share_the_pain.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onHex( _targetEntity, _masterHex, _slaveHex )
	{
		_masterHex.m.IsShareThePainActive = true;

		local id = _targetEntity.getID();
		local user = this.getContainer().getActor();
		local actors = ::Tactical.Entities.getHostileActors(user.getFaction(), user.getTile(), user.getCurrentProperties().getVision());
		local candidates = [];

		foreach (a in actors)
		{
			if (a.getID() == id)
			{
				continue;
			}

			if (a.getCurrentProperties().IsImmuneToDamageReflection)
			{
				continue;
			}

			if (a.getType() == ::Const.EntityType.Hexe || a.getType() == ::Const.EntityType.LegendHexeLeader)
			{
				continue;
			}
			
			if (a.getSkills().hasSkill("effects.charmed_captive"))
			{
				continue;
			}

			if (a.getSkills().hasSkill("effects.hex_slave"))
			{
				continue;
			}
			
			if (a.getSkills().hasSkill("effects.hex_master"))
			{
				continue;
			}

			candidates.push(a);
		}

		if (candidates.len() == 0) return;

		this.m.ChosenTarget = ::MSU.Array.rand(candidates);
		this.m.TempHex = ::new("scripts/skills/hexe/nggh_mod_hex_slave_effect");
		_masterHex.addSlave(this.m.TempHex);
	}

	function onAfterHex( _targetEntity, _masterHex, _slaveHex )
	{
		if (this.m.TempHex == null) return;

		::Tactical.spawnSpriteEffect("effect_pentagram_02", _masterHex.m.Color, this.m.ChosenTarget.getTile(), !this.m.ChosenTarget.getSprite("status_hex").isFlippedHorizontally() ? 10 : -5, 88, 3.0, 1.0, 0, 400, 300);
		this.m.ChosenTarget.getSkills().add(this.m.TempHex);
		this.m.ChosenTarget = null;
		this.m.TempHex = null;
	}

});

