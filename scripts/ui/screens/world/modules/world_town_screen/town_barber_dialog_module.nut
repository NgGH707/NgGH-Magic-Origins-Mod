this.town_barber_dialog_module <- this.inherit("scripts/ui/screens/ui_module", {
	m = {},
	function create()
	{
		this.m.ID = "BarberDialogModule";
		this.ui_module.create();
	}

	function destroy()
	{
		this.ui_module.destroy();
	}

	function clear()
	{
	}

	function onLeaveButtonPressed()
	{
		this.World.getTemporaryRoster().clear();
		this.m.Parent.onModuleClosed();
	}

	function queryRosterInformation()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local roster = [];
		local exclude = [
			this.Const.EntityType.LegendBear,
			this.Const.EntityType.TricksterGod,
		];

		foreach( b in brothers )
		{
			if (b.getFlags().has("Hexe"))
			{
				continue;
			}

			if (b.getFlags().has("egg"))
			{
				continue;
			}

			if (exclude.find(b.getFlags().getAsInt("bewitched")) != null && !b.getFlags().has("luft"))
			{
				continue;
			}

			local background = b.getBackground();
			local e = {
				ID = b.getID(),
				Name = b.getName(),
				ImagePath = b.getImagePath(),
				ImageOffsetX = b.getImageOffsetX(),
				ImageOffsetY = b.getImageOffsetY(),
				BackgroundImagePath = background.getIconColored(),
				BackgroundText = background.getDescription()
			};
			roster.push(e);
		}

		return {
			Title = "Barber",
			SubTitle = "Customize the appearance of your mercenaries at the barber",
			Roster = roster,
			Assets = this.m.Parent.queryAssetsInformation()
		};
	}

	function onEntrySelected( _entityID )
	{
		local roster = this.World.getTemporaryRoster();
		roster.clear();
		local entity = this.Tactical.getEntityByID(_entityID);
		local script = entity.ClassNameHash;
		local sprites = [
			"body",
			"head",
			"beard",
			"hair",
			"tattoo_body",
			"beard_top",
		];

		if (!entity.getFlags().has("human"))
		{
			sprites = entity.getBarberSpriteChange();
		}

		local temp = roster.create(this.IO.scriptFilenameByHash(script));
		temp.copySpritesFrom(entity, sprites);
		temp.setDirty(true);
		return temp.getImagePath();
	}

	function onUpdateAppearance( _data )
	{
		local _entityID = _data[0];
		local _layerID = _data[1];
		local _change = _data[2];
		local temp = this.World.getTemporaryRoster().getAll()[0];
		local color;
		local bros = this.World.getPlayerRoster().getAll();
		local isFemale = false;
		local ethnicity = 0;
		local entity = null;

		foreach( bro in bros )
		{
			if (bro.getID() == _entityID)
			{
				isFemale = bro.getBackground().isFemaleBackground();
				ethnicity = bro.getBackground().getEthnicity();
				entity = bro;
				break;
			}
		}

		if (entity != null && !entity.getFlags().has("human"))
		{
			if (_layerID == "body")
			{
				local custom = null;
				local isSerpent = this.isKindOf(entity, "serpent_player");

				if (isSerpent)
				{
					custom = {
						Variant = [1, 2, 2, 1],
					}
				}

				local result = this.changeIndexNonHuman(entity.getPossibleSprites(_layerID), temp.getSprite(_layerID), _change, custom);

				if (result != null && isSerpent)
				{
					temp.getFlags().set("variant", result);
				}
			}
			else if (_layerID == "head" && temp.hasSprite("head"))
			{
				local custom = null;
				local isNacho = entity.getFlags().has("ghoul") && entity.getSize() >= 2;

				if (entity.getFlags().has("frenzy_wolf"))
				{
					custom = {
						isFrenzy = true,
						sprite = temp.getSprite("head_frenzy"),
					};
				}

				if (isNacho)
				{
					custom = {
						Head = [1, 2, 3, 1, 2, 3],
					}
				}

				local result = this.changeIndexNonHuman(entity.getPossibleSprites(_layerID), temp.getSprite(_layerID), _change, custom);

				if (result != null && isNacho)
				{
					temp.getFlags().set("head", result);
				}
			}
			else if (entity.getFlags().has("spider"))
			{
				if (_layerID == "hair")
				{
					this.changeIndexNonHuman(entity.getPossibleSprites("legs_back"), temp.getSprite("legs_back"), _change, null);
				}
				if (_layerID == "beard")
			    {
			    	this.changeIndexNonHuman(entity.getPossibleSprites("legs_front"), temp.getSprite("legs_front"), _change, null);
			    }
			}

			temp.setDirty(true);
			return temp.getImagePath();
		}

		if (temp.getSprite("hair").HasBrush)
		{
			color = temp.getSprite("hair").getBrush().Name;
		}
		else if (temp.getSprite("beard").HasBrush)
		{
			color = temp.getSprite("beard").getBrush().Name;
		}
		else
		{
			color = "brown";
		}

		if (this.String.contains(color, "_black_"))
		{
			color = "black";
		}
		else if (this.String.contains(color, "_blonde_"))
		{
			color = "blonde";
		}
		else if (this.String.contains(color, "_grey_"))
		{
			color = "grey";
		}
		else if (this.String.contains(color, "_red_"))
		{
			color = "red";
		}
		else
		{
			color = "brown";
		}

		if (_layerID == "color")
		{
			local index = 0;

			foreach( i, s in this.Const.HairColors.All )
			{
				if (s == color)
				{
					index = i;
					break;
				}
			}

			index = index + _change;

			if (index >= this.Const.HairColors.All.len())
			{
				index = 0;
			}
			else if (index < 0)
			{
				index = this.Const.HairColors.All.len() - 1;
			}

			color = this.Const.HairColors.All[index];

			if (isFemale)
			{
				this.changeIndexEx(this.Const.Hair.BarberFemale, temp.getSprite("hair"), 0, "hair", color, "");
				this.changeIndexEx(this.Const.Beards.BarberFemale, temp.getSprite("beard"), 0, "beard", color, "");
			}
			else
			{
				this.changeIndexEx(this.Const.Hair.Barber, temp.getSprite("hair"), 0, "hair", color, "");
				this.changeIndexEx(this.Const.Beards.Barber, temp.getSprite("beard"), 0, "beard", color, "");
			}

			if (temp.getSprite("beard").HasBrush && this.doesBrushExist(temp.getSprite("beard").getBrush().Name + "_top"))
			{
				temp.getSprite("beard_top").setBrush(temp.getSprite("beard").getBrush().Name + "_top");
			}
			else
			{
				temp.getSprite("beard_top").resetBrush();
			}
		}
		else if (_layerID == "body")
		{
			if (isFemale)
			{
				if (ethnicity == 1)
				{
					this.changeIndex(this.Const.Bodies.BarberSouthernFemale, temp.getSprite("body"), _change);
					this.changeIndexEx(this.Const.Tattoos.All, temp.getSprite("tattoo_body"), 0, "", "", temp.getSprite("body").getBrush().Name);
				}
				else if (ethnicity == 2)
				{
					this.changeIndex(this.Const.Bodies.BarberAfricanFemale, temp.getSprite("body"), _change);
					this.changeIndexEx(this.Const.Tattoos.All, temp.getSprite("tattoo_body"), 0, "", "", temp.getSprite("body").getBrush().Name);
				}
				else
				{
					this.changeIndex(this.Const.Bodies.BarberNorthernFemale, temp.getSprite("body"), _change);
					this.changeIndexEx(this.Const.Tattoos.All, temp.getSprite("tattoo_body"), 0, "", "", temp.getSprite("body").getBrush().Name);
				}
			}
			else if (ethnicity == 1)
			{
				this.changeIndex(this.Const.Bodies.BarberSouthernMale, temp.getSprite("body"), _change);
				this.changeIndexEx(this.Const.Tattoos.All, temp.getSprite("tattoo_body"), 0, "", "", temp.getSprite("body").getBrush().Name);
			}
			else if (ethnicity == 2)
			{
				this.changeIndex(this.Const.Bodies.BarberAfricanMale, temp.getSprite("body"), _change);
				this.changeIndexEx(this.Const.Tattoos.All, temp.getSprite("tattoo_body"), 0, "", "", temp.getSprite("body").getBrush().Name);
			}
			else
			{
				this.changeIndex(this.Const.Bodies.BarberNorthernMale, temp.getSprite("body"), _change);
				this.changeIndexEx(this.Const.Tattoos.All, temp.getSprite("tattoo_body"), 0, "", "", temp.getSprite("body").getBrush().Name);
			}
		}
		else if (_layerID == "head")
		{
			if (isFemale)
			{
				if (ethnicity == 1)
				{
					this.changeIndex(this.Const.Faces.SouthernFemale, temp.getSprite("head"), _change);
				}
				else if (ethnicity == 2)
				{
					this.changeIndex(this.Const.Faces.BarberAfricanFemale, temp.getSprite("head"), _change);
				}
				else
				{
					this.changeIndex(this.Const.Faces.AllFemale, temp.getSprite("head"), _change);
				}
			}
			else if (ethnicity == 1)
			{
				this.changeIndex(this.Const.Faces.SouthernMale, temp.getSprite("head"), _change);
			}
			else if (ethnicity == 2)
			{
				this.changeIndex(this.Const.Faces.BarberAfricanMale, temp.getSprite("head"), _change);
			}
			else
			{
				this.changeIndex(this.Const.Faces.AllMale, temp.getSprite("head"), _change);
			}
		}
		else if (_layerID == "hair")
		{
			if (isFemale)
			{
				this.changeIndexEx(this.Const.Hair.BarberFemale, temp.getSprite("hair"), _change, "hair", color, "");
			}
			else
			{
				this.changeIndexEx(this.Const.Hair.Barber, temp.getSprite("hair"), _change, "hair", color, "");
			}
		}
		else if (_layerID == "beard")
		{
			if (isFemale)
			{
				this.changeIndexEx(this.Const.Beards.BarberFemale, temp.getSprite("beard"), _change, "beard", color, "");

				if (temp.getSprite("beard").HasBrush && this.doesBrushExist(temp.getSprite("beard").getBrush().Name + "_top"))
				{
					temp.getSprite("beard_top").setBrush(temp.getSprite("beard").getBrush().Name + "_top");
				}
				else
				{
					temp.getSprite("beard_top").resetBrush();
				}
			}
			else
			{
				this.changeIndexEx(this.Const.Beards.Barber, temp.getSprite("beard"), _change, "beard", color, "");

				if (temp.getSprite("beard").HasBrush && this.doesBrushExist(temp.getSprite("beard").getBrush().Name + "_top"))
				{
					temp.getSprite("beard_top").setBrush(temp.getSprite("beard").getBrush().Name + "_top");
				}
				else
				{
					temp.getSprite("beard_top").resetBrush();
				}
			}
		}
		else if (_layerID == "tattoo")
		{
			this.changeIndexEx(this.Const.Tattoos.All, temp.getSprite("tattoo_body"), _change, "", "", temp.getSprite("body").getBrush().Name);

			if (temp.getSprite("tattoo_body").HasBrush)
			{
				local name = temp.getSprite("tattoo_body").getBrush().Name;
				name = this.String.remove(name, "_" + temp.getSprite("body").getBrush().Name);
				local index = 0;

				foreach( i, s in this.Const.Tattoos.All )
				{
					if (s == name)
					{
						index = i;
						break;
					}
				}

				if (this.doesBrushExist(this.Const.Tattoos.All[index] + "_head"))
				{
					temp.getSprite("tattoo_head").setBrush(this.Const.Tattoos.All[index] + "_head");
				}
				else
				{
					temp.getSprite("tattoo_head").resetBrush();
				}
			}
			else
			{
				temp.getSprite("tattoo_head").resetBrush();
			}
		}

		temp.setDirty(true);
		return temp.getImagePath();
	}

	function onChangeAppearance( _entityID )
	{
		local bro = this.Tactical.getEntityByID(_entityID);
		local temp = this.World.getTemporaryRoster().getAll()[0];
		local sprites = [
			"body",
			"head",
			"beard",
			"hair",
			"tattoo_body",
			"beard_top",
		];

		if (!bro.getFlags().has("human"))
		{
			sprites = bro.getBarberSpriteChange();
		}

		if (temp.getFlags().has("variant"))
		{
			bro.m.Variant = temp.getFlags().getAsInt("variant");
		}

		if (temp.getFlags().has("head"))
		{
			bro.m.Head = temp.getFlags().getAsInt("head");
		}

		bro.copySpritesFrom(temp, sprites);
		bro.setDirty(true);
		this.Sound.play(this.Const.Sound.Barber[this.Math.rand(0, this.Const.Sound.Barber.len() - 1)], 1.0);
		return bro.getImagePath();
	}

	function changeIndexNonHuman( _list, _sprite, _change , _custom )
	{
		if (_list.len() == 0)
		{
			return null;
		}

		local currentBrush = _sprite.HasBrush ? _sprite.getBrush().Name : "";
		local index = 0;

		foreach( i, s in _list )
		{
			if (s == currentBrush)
			{
				index = i;
				break;
			}
		}

		index = index + _change;

		if (index >= _list.len())
		{
			index = 0;
		}
		else if (index < 0)
		{
			index = _list.len() - 1;
		}

		if (_list[index] != "")
		{
			_sprite.setBrush(_list[index]);
		}
		else
		{
			_sprite.resetBrush();
		}

		if (_custom == null)
		{
			return null;
		}

		local ret;

		if (("isFrenzy" in _custom) && _custom.isFrenzy)
		{
			local frenzy = [
	        	"bust_direwolf_01_head",
	        	"bust_direwolf_02_head",
	        	"bust_direwolf_03_head",
	        	"bust_direwolf_01_head",
	        ];

	        if (frenzy[index] != "")
			{
				_custom.sprite.setBrush(frenzy[index]);
			}
			else
			{
				_custom.sprite.resetBrush();
			}
		}
		else if ("Head" in _custom)
		{
			return _custom.Head[index];
		}
		else if ("Variant" in _custom)
		{
			return _custom.Variant[index];
		}

		return ret;
	}

	function changeIndex( _list, _sprite, _change )
	{
		local currentBrush = _sprite.HasBrush ? _sprite.getBrush().Name : "";
		local index = 0;

		foreach( i, s in _list )
		{
			if (s == currentBrush)
			{
				index = i;
				break;
			}
		}

		index = index + _change;

		if (index >= _list.len())
		{
			index = 0;
		}
		else if (index < 0)
		{
			index = _list.len() - 1;
		}

		if (_list[index] != "")
		{
			_sprite.setBrush(_list[index]);
		}
		else
		{
			_sprite.resetBrush();
		}
	}

	function changeIndexEx( _list, _sprite, _change, _prefix, _midfix, _suffix )
	{
		local currentBrush = _sprite.HasBrush ? _sprite.getBrush().Name : "";
		local index = 0;

		if (_prefix != "")
		{
			currentBrush = this.String.remove(currentBrush, _prefix + "_");
		}

		currentBrush = this.String.remove(currentBrush, "red_");
		currentBrush = this.String.remove(currentBrush, "grey_");
		currentBrush = this.String.remove(currentBrush, "black_");
		currentBrush = this.String.remove(currentBrush, "brown_");
		currentBrush = this.String.remove(currentBrush, "blonde_");

		if (_suffix != "")
		{
			currentBrush = this.String.remove(currentBrush, "_" + _suffix);
		}

		foreach( i, s in _list )
		{
			if (s == currentBrush)
			{
				index = i;
				break;
			}
		}

		index = index + _change;

		if (index >= _list.len())
		{
			index = 0;
		}
		else if (index < 0)
		{
			index = _list.len() - 1;
		}

		if (_list[index] != "")
		{
			local brush = _prefix + (_prefix != "" ? "_" : "") + _midfix + (_midfix != "" ? "_" : "") + _list[index] + (_suffix != "" ? "_" : "") + _suffix;

			if (this.doesBrushExist(brush))
			{
				_sprite.setBrush(brush);
			}
			else
			{
				_sprite.resetBrush();
			}
		}
		else
		{
			_sprite.resetBrush();
		}
	}

});

