/*************************************************************************************
    World functions that help adding new charmed unit entries easily
*************************************************************************************/

local inWaitList = [];
local inOverwriteList = [];
local inOverwriteCustomList = [];

::mc_addingValidEntries <- function( _array )
{
    local gt = this.getroottable();

    if (!("CharmedSlave") in gt.Const)
    {
        return this.logError("Fail to add new entries due to 'this.Const.CharmedSlave' don\'t exist");
    }

    if (!("CustomEntries") in gt.Const.CharmedSlave)
    {
        gt.Const.CharmedSlave.CustomEntries <- [];
    }

    if (typeof gt.Const.CharmedSlave.CustomEntries != "array")
    {
        gt.Const.CharmedSlave.CustomEntries = [];
    }

    gt.Const.CharmedSlave.CustomEntries.extend(_array);
    gt.Const.CharmedSlave.CustomEntries.sort(::mc_sortingAscendingByType);
    this.logInfo("Successfully added " + _array.len() + " new entries");
    this.logDebug("---------------");
};

::mc_addOrOverwriteThis <- function( _key , _inputTable , _targetTable )
{
    if (!_inputTable.rawin(_key))
    {
        return;
    }

    local value = ::mc_deepCopy(_inputTable.rawget(_key));

    if (!_targetTable.rawin(_key))
    {
        _targetTable[_key] <- value;
    }
    else 
    {
        _targetTable[_key] = value;
    }

    this.logInfo("Overwriting '" + _key + "'");
};

::mc_overwriteEntries <- function()
{
    if (inOverwriteList.len() == 0 && inOverwriteCustomList.len() == 0)
    {
        return;
    }

    this.logInfo("Overwriting charmed unit entries.....");
    this.logInfo("--------------------");
    local gt = this.getroottable();
    local keywords = [
        "Icon",
        "StatMod",
        "Perks",
        "Difficulty",
        "Custom",
        "PerkTree",
        "Script",
        "Background",
        "Requirements",
        "IsExperienced",
    ];
    local count = 0;

    foreach (i, entry in inOverwriteList )
    {
        this.logInfo((i + 1) + ". " + entry.ID);
        local find = gt.Const.CharmedSlave.Data[entry.Type];

        foreach ( key in keywords )
        {
            ::mc_addOrOverwriteThis(key, entry, find);
        }

        ++count;
    }

    foreach (i, entry in inOverwriteCustomList )
    {
        this.logInfo((count + i + 1) + ". " + entry.ID);
        local index = ::mc_findThisInArray(entry.Type, gt.Const.CharmedSlave.CustomEntries, "Type");

        if (index == null)
        {
            this.logError("Error - Can't find an existed entry of " + entry.ID + " to overwrite");
            continue;
        }

        local find = gt.Const.CharmedSlave.CustomEntries[index];

        foreach ( key in keywords )
        {
            ::mc_addOrOverwriteThis(key, entry, find);
        }
    }

    this.logInfo("Finishing overwrite entries.....");
    this.logDebug("---------------");
    inOverwriteList.clear();
    inOverwriteCustomList.clear();
};

::mc_processingEntries <- function()
{
    if (inWaitList.len() == 0)
    {
        return;
    }

    this.logDebug("--------------------");
    this.logInfo("Processing new charmed unit entries.....");
    this.logInfo("--------------------");

    local pretext = "scripts/entity/tactical/";
    local scripts = this.IO.enumerateFiles(pretext);
    local pretextBG = "scripts/skills/backgrounds/";
    local backgrounds = this.IO.enumerateFiles(pretextBG);
    local valid = [];
    local discarded = [];

    foreach (i, entry in inWaitList )
    {
        this.logInfo((i + 1) + ". " + entry.ID);
        local isHuman = !entry.rawin("Background") && !entry.rawin("Script");
        local isValid = true;

        if (isHuman)
        {
            this.logInfo("Is considered to be a human entry");
        }
        else
        {
            if (entry.rawin("Background") && backgrounds.find(pretextBG + entry.Background) == null)
            {
                this.logError("Invalid Entry - Background file from 'Background' doesn't exist");
                isValid = false;
            }
            
            if (entry.rawin("Script") && scripts.find(pretext + entry.Script) == null)
            {
                this.logError("Invalid Entry - Entity script file from 'Script' doesn't exist");
                isValid = false;
            }
        }

        if (!isHuman && !entry.rawin("Requirements"))
        {
            this.logError("Invalid Entry - Is missing 'Requirements'");
            isValid = false;
        }

        if (!entry.rawin("PerkTree"))
        {
            this.logError("Invalid Entry - Is missing 'PerkTree'");
            isValid = false;

            if (isHuman)
            {
                this.logError("Please add 'PerkTree' with a human background file name");
            }
            else
            {
                this.logError("Please add 'PerkTree' with a perk tree, check !mods_preload/mod_nggh_hexen_origin_new_perk_defs for reference");
            }
        }

        if (!isHuman)
        {
            if (!entry.rawin("Custom"))
            {
                this.logError("Invalid Entry - Is missing 'Custom'");
                isValid = false;
            }
            else
            {
                if (!entry.Custom.rawin("BgModifiers"))
                {
                    this.logError("Invalid Entry - Is missing 'BgModifiers' in 'Custom'");
                    isValid = false;
                }

                if (!entry.Custom.rawin("Talents"))
                {
                    this.logError("Invalid Entry - Is missing 'Talents' in 'Custom'");
                    isValid = false;
                }
            }
        }

        if (isValid)
        {
            this.logInfo("Accepting.....");
            valid.push(entry);
        }
        else 
        {
            this.logError("Discarding.....");
            discarded.push(entry);
        }

        this.logInfo("--------------------");
    }

    if (discarded.len() != 0)
    {
        this.logInfo("Total discarded entries: " + discarded.len());
    }

    this.logInfo("Total valid entries: " + valid.len());

    if (valid.len() == 0)
    {
        this.logInfo("No entry can be added.....");
        return this.logDebug("--------------------");
    }

    this.logInfo("Adding valid entries.....");
    ::mc_addingValidEntries(valid);
    inWaitList.clear();
};

::mc_registerCharmedEntries <- function ( _array )
{
    if (typeof _array != "array")
    {
        return this.logError("Invalid Input Array - Not an array");
    }

    local a = [];
    local b = [];
    local c = [];
    local gt = this.getroottable();
    this.logDebug("--------------------");
    this.logInfo("Proceeding to quick check applied entries...");
    //removing duplicated entry and quick check for valid
    foreach (i, table in _array )
    {
        if (typeof table != "table")
        {
            this.logError("Invalid Entry - Entry must be defined as a table");
            continue;
        }

        if (!table.rawin("ID"))
        {
            this.logError("Invalid Entry - Is missing 'ID' to identify this entry name");
            continue;
        }

        if (!table.rawin("Type"))
        {
            this.logError("Invalid Entry - Is missing 'Type'");
            continue;
        }

        if (table.rawget("Type") <= gt.Const.CharmedSlave.Data.len() - 1)
        {
            b.push(table);
            continue;
        }

        local input = [];
        input.extend(a);
        input.extend(inWaitList);

        if (::mc_hasThisInArray(table.Type, input, "Type"))
        {
            c.push(table);
            continue;
        }

        a.push(table);
    }

    if (a.len() == 0 && b.len() == 0 && c.len() == 0)
    {
        return this.logError("All entries are invalid");
    }

    inWaitList.extend(a);
    inWaitList.sort(::mc_sortingAscendingByType);
    inOverwriteList.extend(b);
    inOverwriteList.sort(::mc_sortingAscendingByType);
    inOverwriteCustomList.extend(c);
    inOverwriteCustomList.sort(::mc_sortingAscendingByType);
};


/*************************************************************************************
    A library contains various world functions that seem to be useful for my mod
*************************************************************************************/


//Check if tables in an array has a specific key value equal to a certain value
::mc_hasThisInArray <- function( _value, _array, _key)
{
    foreach ( table in _array ) 
    {
        if (typeof table != "table" || !table.rawin(_key))
        {
            continue;
        }

        if (table.rawget(_key) == _value)
        {
            return true;
        }
    }

    return false;
};
::mc_findThisInArray <- function( _value, _array, _key)
{
    foreach (i, table in _array ) 
    {
        if (typeof table != "table" || !table.rawin(_key))
        {
            continue;
        }

        if (table.rawget(_key) == _value)
        {
            return i;
        }
    }

    return null;
};


::mc_sortingAscendingByType <- function( _a, _b )
{
    if (_a.Type < _b.Type)
    {
        return -1;
    }
    else if (_a.Type > _b.Type)
    {
        return 1;
    }

    return 0;
};
::mc_sortingDescendingByType <- function( _a, _b )
{
    if (_a.Type < _b.Type)
    {
        return 1;
    }
    else if (_a.Type > _b.Type)
    {
        return -1;
    }

    return 0;
};


//deep copy table/array, work better than "clone" keyword
::mc_deepCopy <- function( _container ) 
{ 
    // Container must not have circular references 
    switch (typeof _container) 
    {
    case "table": 
        local result = clone _container; 
        foreach( k,v in _container) 
        {
        	result[k] = ::mc_deepCopy(v);
        }
        return result; 

    case "array": 
        return _container.map(::mc_deepCopy);

    default: return _container;
    }
};


//randomly select an index in an array
::mc_randArrayIndex <- function( _array , _min = 0 , _max = 0 )
{
    if (typeof _array != "array")
    {
        return null;
    }

    local len = _array.len();

    if (len == 0)
    {
        return null;
    }

    if (_max != 0 && _max - 1 < len)
    {
        _max = _max
    }
    else
    {
        _max = len - 1;
    }

    if (_min - 1 > len || _min > _max) _min = 0;
    return this.Math.rand(_min, _max);
};


//randomly select a slot in an array
::mc_randArray <- function( _array , _min = 0 , _max = 0 )
{
    local index = ::mc_randArrayIndex(_array, _min, _max);

    if (index == null)
    {
        return null;
    }

    return _array[index];
};

