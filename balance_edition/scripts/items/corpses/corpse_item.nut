this.corpse_item <- this.inherit("scripts/items/item", {
	m = {
		CorpseValue = 0.0,
		ConditionHasBeenProcessed = 0.0,
		StaminaModifier = 0,
		IsToBeButcheredQueue = 0,
		IsToBeButchered = false,
		IsPlayer = false,
		IsHuman = false,
		IsMaintained = false,
		IsHeadLess = false,
		IsTail = false,
		IsRotten = false,
		IsBone = false,
		IsEdible = true,
		IsBoss = false,
		AddGenericSkill = true,
		ShowOnCharacter = false,
		Sprite = null,
		SpriteCorpse = null,
		Entity = null,
		Loots = [],
	},
	function create()
	{
		this.m.ID = "items.necro.corpse";
		this.m.SlotType = this.Const.ItemSlot.Bag;
		this.m.ItemType = this.Const.Items.ItemType.Corpse | this.Const.Items.ItemType.Misc;
		this.m.IsAllowedInBag = true;
		this.m.IsDroppedAsLoot = false;
		this.m.IconLarge = "";
		this.m.Condition = 1.0;
		this.m.ConditionMax = 0.0;
	}

	function getRepair()
	{
		return 1;
	}

	function getRepairMax()
	{
		return 1;
	}

	function isToBeRepaired()
	{
		return this.m.IsMaintained;
	}

	function isToBeSalvaged()
	{
		return this.isToBeButchered() ? 1 : 0;
	}

	function canBeSalvaged()
	{
		return false;
	}

	function getName()
	{
		local ret = this.item.getName();

		if (this.m.IsBone)
		{
			return ret + " Bone Pile";
		}

		local special = [
			this.Const.EntityType.SandGolem,
			this.Const.EntityType.Schrat,
			this.Const.EntityType.SchratSmall,
			this.Const.EntityType.SandGolem,
			this.Const.EntityType.SandGolem,
		];

		if (special.find(this.m.Variant) != null)
		{
			return ret + " Remains";
		}

		if (this.m.IsHuman)
		{
			return ret + " Corpse";
		}

		return ret + " Carcass";
	}

	function getDescription()
	{
		local ret = this.item.getDescription();

		if (this.m.MedicinePerDay != 0 && this.isMaintained())
		{
			ret += " Is preserved with [color=" + this.Const.UI.Color.NegativeValue + "]" + this.getMedicinePerDay() + "[/color] units of medicine per day.";
		}

		return ret;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		result.extend([
			{
				id = 3,
				type = "image",
				image = this.getIcon()
			},
			{
				id = 66,
				type = "text",
				text = this.getValueString()
			},
		]);

		if (this.m.ConditionMax > 1 && this.m.ConditionMax >= 1)
		{
			result.push({
				id = 4,
				type = "progressbar",
				icon = "ui/icons/salvage_item.png",
				value = this.getCondition(),
				valueMax = this.getConditionMax(),
				text = "" + this.getCondition() + " / " + this.getConditionMax() + "",
				style = "armor-body-slim"
			});
		}

		result.push({
			id = 65,
			type = "text",
			text = "Necromancy potential: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.CorpseValue + "[/color]"
		});

		if (this.m.MedicinePerDay != 0 && !this.isMaintained())
		{
			result.push({
				id = 67,
				type = "text",
				text = "Will rot in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.getDaysToRot() + "[/color] days."
			});
		}

		if (this.getStaminaModifier() < 0)
		{
			result.push({
				id = 68,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color]"
			});
		}

		result.push({
			id = 69,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can be butchered"
		});

		return result;
	}

	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return "" + this.Math.floor(this.m.Condition / (this.m.ConditionMax * 1.0) * 100) + "%";
	}

	function getAmountColor()
	{
		return this.Const.Items.ConditionColor[this.Math.min(this.Math.max(0, this.Math.floor(this.m.Condition / (this.m.ConditionMax * 1.0) * (this.Const.Items.ConditionColor.len() - 1))), this.Const.Items.ConditionColor.len() - 1)];
	}

	function getStaminaModifier()
	{
		return this.m.StaminaModifier;
	}

	function getIcon()
	{
		local ret = "corpses/" + this.item.getIcon();
		if (this.m.IsHeadLess && !this.m.IsTail) ret += "_headless";
		if (this.m.IsTail) ret += "_tail";
		return ret + ".png";
	}

	function getValue()
	{
		return this.Math.floor(this.m.Value * this.getConditionPct());
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/body_fall_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function getDaysToRot()
	{
		return this.Math.max(1, this.Math.floor(this.getConditionPct() / (this.Const.Necro.ConditionLossPerSixHour * 4)));
	}

	function isToBeButchered()
	{
		return this.m.IsToBeButchered;
	}

	function isToBeButcheredQ()
	{
		return this.m.IsToBeButcheredQueue;
	}

	function setToBeButchered( _r, _idx )
	{
		if (_r && this.getConditionHasBeenProcessed() >= this.getCondition())
		{
			this.m.IsToBeButcheredQueue = 0;
			return false;
		}

		this.m.IsToBeButchered = _r;
		this.m.IsToBeButcheredQueue = _idx;
		return true;
	}

	function getConditionHasBeenProcessed()
	{
		return this.m.ConditionHasBeenProcessed;
	}

	function getConditionPct()
	{
		return this.Math.minf(1.0, this.getCondition() / this.Math.maxf(1.0, this.getConditionMax()));
	}

	function setProcessedCondition( _c )
	{
		this.m.ConditionHasBeenProcessed = _c;
	}

	function setToBeMaintain( _r )
	{
		this.m.IsMaintained = _r;
	}

	function isMaintained()
	{
		return this.m.IsMaintained;
	}

	function getMedicinePerDay()
	{
		if (this.m.MedicinePerDay == 0)
		{
			return 0;
		}

		foreach (bro in this.World.getPlayerRoster().getAll())
		{
			local skill = bro.getSkills().getSkillByID("perk.legend_conservation");

			if (skill != null)
			{
				return this.Math.floor(this.m.MedicinePerDay * skill.m.MedicinePerDayMult);
			}
		}

		return this.m.MedicinePerDay;
	}

	function getExpectedItemAfterButchered()
	{
		local ret = [];

		foreach (entry in this.m.Loots)
		{
			foreach (script in entry.Scripts)
			{
				local item = this.new("scripts/items/" + script);
				local result = {
					Item = item,
					InstanceID = item.getID(),
					ImagePath = item.getIcon(),
				};

				if ("IsSupplies" in entry)
				{
					local conversionRate = ("Conversion" in entry) ? entry.Conversion : 10.0;
					result.Max <- this.Math.max(1, this.m.ConditionMax / conversionRate);
					result.Min <- this.Math.max(1, this.getConditionHasBeenProcessed() / conversionRate);
				}
				else
				{
					result.Max <- entry.Max;
					result.Min <- entry.Min;
				}

				ret.push(result);
			}
		}

		return ret;
	}

	function onButchered()
	{
		local ret = [];
		local isUpgraded = this.World.Camp.getBuildingByID(this.Const.World.CampBuildings.Butcher).getUpgraded();

		foreach (entry in this.m.Loots)
		{
			if ("IsSupplies" in entry)
			{
				local conversionRate = ("Conversion" in entry) ? entry.Conversion : 10.0;
				local supply = this.new("scripts/items/" + this.MSU.Array.getRandom(entry.Scripts));
				supply.setAmount(this.Math.maxf(1.0, this.getConditionHasBeenProcessed() / conversionRate));
				supply.m.GoodForDays = supply.m.GoodForDays <= 2 ? this.Math.rand(2, 3) : this.Math.rand(2, supply.m.GoodForDays);
				supply.m.BoughtAtPrice = this.Math.rand(1, 3) * supply.m.Amount;
			}
			else
			{
				local chance = this.Math.ceil(67 * this.Math.minf(1.0, this.getConditionHasBeenProcessed() / this.Math.maxf(1.0, this.getConditionMax()))) + (isUpgraded ? 10 : 0);
				local num = entry.Max;
				local guarantee = entry.Min;

				for (local i = 0; i < num; ++i)
				{
					local isDrop = false;

					if (this.Math.rand(1, 100) <= chance)
					{
						isDrop = true;
					}
					else
					{
						isDrop = (--guarantee >= 0);
					}

					if (isDrop)
					{
						ret.push(this.new("scripts/items/" + this.MSU.Array.getRandom(entry.Scripts)));
					}
				}
			}
		}

		return ret;
	}

	function onLoseCondition()
	{
		if (!this.World.Assets.isUsingProvisions())
		{
			return;
		}

		if (this.m.MedicinePerDay == 0 || this.World.Camp.isCamping())
		{
			return;
		}

		local isInMaintainState = this.isMaintained();
		local isFailToMaintain = !isInMaintainState;

		if (isInMaintainState)
		{
			local requiredMed = this.getMedicinePerDay() / 4;
			local currentMed = this.World.Assets.getMedicine();

			if (currentMed >= requiredMed)
			{
				isFailToMaintain = false;
				this.World.Assets.addMedicine(-requiredMed);
			}
		}
		
		if (isFailToMaintain)
		{
			local currenCondition = this.getCondition();
			local newCondition = this.getConditionMax() * this.Math.maxf(0, this.getConditionPct() - this.Const.Necro.ConditionLossPerSixHour);

			if (newCondition == currenCondition)
			{
				newCondition = currenCondition - 1.0;
			}

			if (newCondition <= 0.0)
			{
				this.m.IsGarbage = true;
			}
			else
			{
				this.setCondition(newCondition);
				if (this.getConditionHasBeenProcessed() >= newCondition) this.setProcessedCondition(newCondition);
			}
		}
	}

	function updateVariant()
	{
		local data = this.Const.NecroCorpseType[this.m.Variant];

		if (data.len() != 0)
		{
			foreach (key, value in data)
			{
				this.m[key] = value;
			}
		}
		else
		{
			this.m.IsGarbage = !this.m.IsHuman;
		}

		if (this.m.IsHuman)
		{
			this.m.MedicinePerDay = 2;
			this.m.Value = 0;
			this.m.Icon = "icon_corpse_human_70x70";
			this.m.Loots.push({
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			});
		}
	}

	function setUpAsLootInBattle( _entity, _type, _corpse, _fatalityType )
	{
		this.m.Variant = _type;
		this.m.Name = _entity.getNameOnly();
		this.m.IsTail = this.isKindOf(_entity, "lindwurm_tail") || this.isKindOf(_entity, "legend_stollwurm_tail");
		this.m.ConditionMax = this.m.IsTail ? _entity.getHitpointsMax() * 0.5 : _entity.getHitpointsMax();
		this.m.StaminaModifier = -1 * this.Math.max(1, this.m.ConditionMax / 12.5);
		this.m.IsHeadLess = !_corpse.IsHeadAttached;
		this.m.IsHuman = _entity.getFlags().has("human");
		this.updateVariant();
		local isChampion = _entity.m.IsMiniboss;
		local isLeader = this.Const.Necro.LeaderTypeEnemies.find(_type) != null;
		//local isLeader = this.Const.Necro.LeaderTypeEnemies.find(_type) != null;
		local injuries = _entity.getSkills().getAllSkillsOfType(this.Const.SkillType.Injury);
		local mod = 1.0;

		switch (_fatalityType)
		{
		case this.Const.FatalityType.Decapitated:
			mod = this.Math.rand(58, 67) * 0.01;
			break;

		case this.Const.FatalityType.Disemboweled:
			mod = this.Math.rand(66, 75) * 0.01;
			break;

		case this.Const.FatalityType.Smashed:
			mod = this.Math.rand(58, 67) * 0.01;
			break;

		case this.Const.FatalityType.Unconscious:
			mod = 1.0;
			break;

		case this.Const.FatalityType.Devoured:
			mod = 0.0;
			break;

		case this.Const.FatalityType.Suicide:
			mod = this.Math.rand(90, 100) * 0.01;
			break;

		case this.Const.FatalityType.Kraken:
			mod = 0.0;
			break;
	
		default:
			mod = this.Math.rand(73, 85) * 0.01;
		}

		if (isChampion)
		{
			mod *= 1.25;
		}

		if (isLeader)
		{
			mod *= 1.1;
		}

		if (mod == 0.0)
		{
			this.m.IsGarbage = true;
		}
		else
		{
			mod = this.Math.minf(1.0, this.Math.maxf(0.01, mod - injuries.len() * 0.12));
		}

		this.setCondition(this.getConditionMax() * mod);
		this.m.CorpseValue = 100 * mod * (isChampion ? this.Math.rand(90, 110) : this.Math.rand(95, 125)) * 0.01 * (isLeader ? 1.1 : 1.0);
		this.onAfterSetUpAsLoot();
	}

	function onAfterSetUpAsLoot()
	{
		if (this.m.IsBoss)
		{
			this.m.CorpseValue = 999.0;
		}

		this.m.CorpseValue = this.Math.floor(this.m.CorpseValue * 10) * 0.1;
	}

	function onUpdateProperties( _properties )
	{
		_properties.Stamina += this.getStaminaModifier();
	}

	function isUnleashed()
	{
		return this.m.Entity != null;
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;
	}

	function onCombatFinished()
	{
		if (this.m.Entity == null)
		{
			return
		}

		if (this.m.Entity.m.IsAlive)
		{
			this.setEntity(null);
			this.World.Assets.getStash().add(this);
			return;
		}

		this.setEntity(null);
	}

	function onSerialize( _out )
	{
		_out.writeBool(this.m.IsHuman);
		this.item.onSerialize(_out);
		_out.writeString(this.m.Name);
		_out.writeBool(this.m.IsHeadLess);
		_out.writeBool(this.m.IsTail);
		_out.writeBool(this.m.IsPlayer);
		_out.writeBool(this.m.IsRotten);
		_out.writeBool(this.m.IsBone);
		_out.writeBool(this.m.IsMaintained);
		_out.writeBool(this.m.IsToBeButchered);
		_out.writeU16(this.m.IsToBeButcheredQueue);
		//_out.writeU16(this.m.FoodDone);
		_out.writeI8(this.m.StaminaModifier);
		_out.writeF32(this.m.ConditionMax);
		_out.writeF32(this.m.CorpseValue);
		_out.writeF32(this.m.ConditionHasBeenProcessed);
	}

	function onDeserialize( _in )
	{
		this.m.IsHuman = _in.readBool();
		this.item.onDeserialize(_in);
		this.m.Name = _in.readString();
		this.m.IsHeadLess = _in.readBool();
		this.m.IsTail = _in.readBool();
		this.m.IsPlayer = _in.readBool();
		this.m.IsRotten = _in.readBool();
		this.m.IsBone = _in.readBool();
		this.m.IsMaintained = _in.readBool();
		this.m.IsToBeButchered = _in.readBool();
		this.m.IsToBeButcheredQueue = _in.readU16();
		//this.m.FoodDone = _in.readU16(); // new, will cause save corruption
		this.m.StaminaModifier = _in.readI8();
		this.m.ConditionMax = _in.readF32();
		this.m.CorpseValue = _in.readF32();
		local a = _in.readF32();
		this.setProcessedCondition(a);
	}

});

