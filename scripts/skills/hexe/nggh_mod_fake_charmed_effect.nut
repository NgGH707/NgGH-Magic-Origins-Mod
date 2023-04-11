this.nggh_mod_fake_charmed_effect <- ::inherit("scripts/skills/skill", {
	m = {
		SimpLevel = 1,
		HasBeenRemoved = false,

		// UwU when you are no longer want to be a simp
		OldAIAgent = null,
		IsMutiny = false,
		MutinyChance = 0,
	},
	function create()
	{
		this.m.ID = "effects.simp";
		this.m.Name = "Simp";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = "";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function isMutiny()
	{
		return this.m.IsMutiny;
	}

	function getSimpLevel()
	{
		return this.m.SimpLevel;
	}

	function setSimpLevel( _lv )
	{
		this.m.SimpLevel = ::Math.max(0, ::Math.min(::Const.Simp.MaximumLevel, _lv));
	}

	function gainSimpLevel()
	{
		this.setSimpLevel(this.m.SimpLevel + 1);
	}

	function loseSimpLevel()
	{
		this.setSimpLevel(this.m.SimpLevel - 1);
	}

	function getName()
	{
		if (this.isMutiny())
		{
			return "Simp No More";
		}

		return this.m.Name + " (lv. " + this.m.SimpLevel + ")";
	}

	function getDescription()
	{
		return "This character has been charmed by you. He no longer has any control over his actions and is a puppet that has no choice but to obey his e-girl overlord, your everyday simp no more no less.";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
		];

		local lv = this.getSimpLevel();

		if (lv == 0)
		{
			ret.push({
				id = 3,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+20[/color] Resolve"
			});
			return ret;
		}
		
		local table = this.compileBonusTable(lv, ::Const.Simp.DefaultBonusTooltipValue, true);
		local i = ret.len();

		foreach (k, c in table)
		{
			++i;

			ret.push({
				id = i,
				type = "text",
				icon = "ui/icons/" + c.Icon + ".png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + c.Value + "%[/color] " + c.Name
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.DailyWageMult = 0.0;

		local lv = this.getSimpLevel();

		if (lv == 0)
		{
			_properties.Bravery += 20;
			_properties.SurviveWithInjuryChanceMult *= 0.0;
			return;
		}

		local table = this.compileBonusTable(lv, ::Const.Simp.DefaultBonusValue);

		foreach (k, c in table)
		{
			_properties[k] *= 1.0 + c.Value;
		}
	}

	function compileBonusTable( _level = null, _value = ::Const.Simp.DefaultBonusValue, _forTooltips = false )
	{
		local table = {};

		if (_level == null)
		{
			_level = this.getSimpLevel();
		}

		for (local i = 1; i <= _level; ++i)
		{
			this.fillBonusTable(table, _value, ::Const.Simp.Bonuses[i], _forTooltips);
		}

		foreach (array in ::Const.Simp.SpecialBonuses)
		{
			if (_level < array[3])
			{
				continue;
			}

			this.fillBonusTable(table, _value, array, _forTooltips);
		}

		return table;
	}

	function fillBonusTable( _table, _value, _array , _forTooltips = false )
	{
		local _key = _array[0];

		if (_table.rawin(_key))
		{
			_table[_key].Value += _value;
		}
		else
		{
			_table.rawset(_key, {
				Value = _value,
			});

			if (_forTooltips)
			{
				_table[_key].Name <- _array[1];
				_table[_key].Icon <- _array[2];
			}
		}
	}

	function resetToDefault()
	{
		if (this.m.SimpLevel != 0)
		{
			return;
		}

		this.m.SimpLevel = 0;
		this.m.IsMutiny = false;
		this.getContainer().getActor().setFaction(::Const.Faction.Player);
		
		if (this.m.OldAIAgent != null)
		{
			this.getContainer().getActor().setAIAgent(this.m.OldAIAgent);
			this.getContainer().getActor().getAIAgent().setActor(this.getContainer().getActor());
			this.m.OldAIAgent = null;
		}
	}

	function onTurnEnd()
	{
		if (this.getSimpLevel() > 0)
		{
			return;
		}

		if (this.isMutiny())
		{
			return;
		}

		if (::Math.rand(1, 100) > this.m.MutinyChance)
		{
			return;
		}

		local actor = this.getContainer().getActor().get();
		this.spawnIcon("status_effect_106", actor.getTile());
		this.m.OldAIAgent = actor.getAIAgent();
		this.m.IsMutiny = true;

		actor.getFlags().set("Charmed", true);
		actor.setFaction(::World.FactionManager.m.Factions.find(::World.FactionManager.getFactionOfType(::Const.FactionType.Arena)));
		actor.setAIAgent(::new("scripts/ai/tactical/agents/charmed_player_agent"));
		actor.getAIAgent().setActor(actor);
	}

	function onRemoved()
	{
		if (this.m.HasBeenRemoved) return;

		local actor = this.getContainer().getActor();

		if (this.m.OldAIAgent != null)
		{
			actor.setAIAgent(this.m.OldAIAgent);
		}

		actor.getFlags().set("Charmed", false);
		actor.setFaction(::Const.Faction.Player);
		actor.setDirty(true);

		this.m.OldAIAgent = null;
		this.m.HasBeenRemoved = true;
	}

	function onDeath( _fatalityType )
	{
		this.onRemoved();
	}

	function onCombatStarted()
	{
		this.m.MutinyChance = ::World.Flags.get("isExposed") ? ::Math.rand(10, 20) : ::Math.rand(2, 5);
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();

		if (!this.isMutiny())
		{
			return;
		}

		if (::Tactical.Entities.getInstancesNum(::Const.Faction.Player) == 0)
		{
			//::World.getPlayerRoster().remove(this.getContainer().getActor().get());
			this.getContainer().getActor().kill(null, null, ::Const.FatalityType.Suicide);
		}
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(this.m.SimpLevel);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.SimpLevel = _in.readU8();
	}

});

