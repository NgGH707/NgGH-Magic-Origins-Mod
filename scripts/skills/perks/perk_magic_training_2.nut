this.perk_magic_training_2 <- this.inherit("scripts/skills/skill", {
	m = {
		Tier = this.Const.MC_MagicTier.Intermediate,
		MagicSkills = [],
	},
	function create()
	{
		this.m.ID = "perk.magic_training_2";
		this.m.Name = this.Const.Strings.PerkName.MC_MagicTraining2;
		this.m.Description = this.Const.Strings.PerkDescription.MC_MagicTraining2;
		this.m.Icon = "ui/perks/perk_magic_training_2.png";
		this.m.IconMini = "perk_magic_training_2_mini";
		this.m.Overlay = "perk_magic_training_2";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (this.m.MagicSkills.len() == 0)
		{
			local actor = this.getContainer().getActor();
			local job = actor.getFlags().getAsInt("mc_mage");
			local skill = this.Const.MC_Job.pickSkillRandomly(job, this.m.Tier);

			if (skill != null)
			{
				this.m.MagicSkills.push({
					Script = skill,
					ID = null,
				});
			}
		}

		foreach ( info in this.m.MagicSkills )
		{
			local skill = this.new("scripts/skills/" + info.Script);
			this.m.Container.add(skill);
			info.ID = skill.getID();
		}
	}

	function onRemoved()
	{
		foreach ( info in this.m.MagicSkills )
		{
			if (info.ID != null)
			{
				this.m.Container.removeByID(info.ID);
			}
		}
	}
	
	function onSerialize( _out )
	{
		_out.writeU8(this.m.MagicSkills.len());

		foreach (i, info in this.m.MagicSkills) 
		{
		    _out.writeString(info.Script);
		}

		this.skill.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local num = _in.readU8();

		for ( local i = 0 ; i < num ; i = i ) 
		{
			this.m.MagicSkills.push({
				Script = _in.readString(),
				ID = null,
			});
		    i = ++i;
		}

		this.skill.onDeserialize(_in);
	}

});

