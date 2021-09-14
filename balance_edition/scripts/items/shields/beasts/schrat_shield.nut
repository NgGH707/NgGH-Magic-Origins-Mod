this.schrat_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.schrat";
		this.m.Name = "Schrat\'s Shield";
		this.m.Description = "A living shield make out of living wood.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 0;
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = 0;
		this.m.Condition = 32;
		this.m.ConditionMax = 32;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_schrat_shield_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_schrat_shield_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "bust_schrat_shield_0" + this.m.Variant + "_dead";
		this.m.IconLarge = "shields/inventory_schrat_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_schrat_shield_0" + this.m.Variant + ".png";
	}
	
	function getTooltip()
	{
		local result = this.shield.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Regenerates itself by [color=" + this.Const.UI.Color.PositiveValue + "]4[/color] points of durability each turn."
		});
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Will be removed after battle[/color]"
		});
		return result;
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

	function onTurnStart()
	{
		this.m.Condition = this.Math.min(this.m.ConditionMax, this.m.Condition + 4);
		this.updateAppearance();
	}

	function onCombatFinished()
	{
		this.getContainer().unequip(this);
	}

	function applyShieldDamage( _damage, _playHitSound = true )
	{
		if (this.m.Condition == 0)
		{
			return;
		}

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
		{
			_damage = this.Math.max(1, this.Math.ceil(_damage * 0.5));
		}

		local Condition = this.m.Condition;
		Condition = this.Math.maxf(0.0, this.m.Condition - _damage);

		if (Condition == 0)
		{
			if (this.m.SoundOnDestroyed.len() != 0)
			{
				this.Sound.play(this.m.SoundOnDestroyed[this.Math.rand(0, this.m.SoundOnDestroyed.len() - 1)], this.Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
			}

			if (this.m.ShieldDecal.len() > 0)
			{
				local ourTile = this.getContainer().getActor().getTile();
				local candidates = [];

				for( local i = 0; i < this.Const.Direction.COUNT; i = i )
				{
					if (!ourTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = ourTile.getNextTile(i);

						if (tile.IsEmpty && !tile.Properties.has("IsItemSpawned") && !tile.IsCorpseSpawned && tile.Level <= ourTile.Level + 1)
						{
							candidates.push(tile);
						}
					}

					i = ++i;
					i = i;
				}

				if (candidates.len() != 0)
				{
					local tileToSpawnAt = candidates[this.Math.rand(0, candidates.len() - 1)];
					tileToSpawnAt.spawnDetail(this.m.ShieldDecal);
					tileToSpawnAt.Properties.add("IsItemSpawned");
					tileToSpawnAt.Properties.add("IsShieldItemSpawned");
				}
				else if (!ourTile.Properties.has("IsItemSpawned") && !ourTile.IsCorpseSpawned)
				{
					ourTile.spawnDetail(this.m.ShieldDecal);
					ourTile.Properties.add("IsItemSpawned");
					ourTile.Properties.add("IsShieldItemSpawned");
				}
			}

			local actor = this.getContainer().getActor();
			local isPlayer = this.m.LastEquippedByFaction == this.Const.Faction.Player || actor != null && !actor.isNull() && this.isKindOf(actor.get(), "player");
			this.m.Container.unequip(this);
			this.m.Condition = Condition;
		}
		else
		{
			this.m.Condition = Condition;

			if (_playHitSound && this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
				this.Sound.play(this.m.SoundOnDestroyed[this.Math.rand(0, this.m.SoundOnDestroyed.len() - 1)], this.Const.Sound.Volume.Skill * 0.33, this.getContainer().getActor().getPos());
			}

			if (this.m.ShowOnCharacter)
			{
				local app = this.getContainer().getAppearance();

				if (this.m.Condition == 0)
				{
					app.Shield = "";
				}
				else if (this.m.Condition / (this.m.ConditionMax * 1.0) <= this.Const.Combat.ShowDamagedShieldThreshold)
				{
					app.Shield = this.m.SpriteDamaged;
				}
				else
				{
					app.Shield = this.m.Sprite;
				}

				this.getContainer().updateAppearance();
			}
		}
	}

});

