settings_file = open("settings.txt", "r")
npc_units_custom = open("scripts/npc/npc_units_custom.txt", "w")
addon_russian = open("resource/addon_russian.txt","w")
addon_english = open("resource/addon_english.txt","w")
unitsTable = open("scripts/vscripts/unitsTable.lua","w")
npc_abilities_custom = open("scripts/npc/npc_abilities_custom.txt", "w")
npc_abilities_custom_template = open("scripts/npc/npc_abilities_custom_template.txt", "r")
main_xml_template = open("../../../content/dota_addons/test/panorama/layout/custom_game/test_template.xml","r")
main_xml = open("../../../content/dota_addons/test/panorama/layout/custom_game/test.xml","w")

unitsID = 0
#dicts
colors = {"legendary" : "#D32CE6", "rare": "#4B69FF", "common" : "#B0C3D9",
          "green" : "#C0DF81", "yellow": "#FEEC86", "purple" : "#A33AF2",
          "red" : "#FE2712", "blue" : "#183BF0", "white": "#F7FCFE"}

rare_colors = {"легендарный" : "legendary", "редкость" : "rare", "обычный": "common"}
type_colors = {"саппорт": "green","особый" : "purple", "дамагер" : "red", "танк" : "blue"}
hp_colors = {"очень мало": "white", "средне": "yellow", "мало" : "green", "много" : "blue"}
speed_colors = {"высокая":"purple", "средняя": "yellow", "медленная" : "green"}
dist_colors = {"высокая": "purple", "средняя": "yellow","нет":"white", "низкая":"green"}
attack_type_colors = {"нет":"white", "дальник": "red", "ближник" : "blue"}
damage_colors = {"средний" : "yellow", "нет" : "white", "низкий":"green","высокий":"red"}
          
hp_dict = {"средне": 150, "мало" : 80,"очень мало" : 30, "много":600}
speed_dict = {"высокая" : 250,"средняя": 200, "медленная": 150}
dist_dict = {"высокая": 600, "средняя": 400,"нет":0,"низкая" : 200}
attack_type_dict = {"нет":"DOTA_UNIT_CAP_RANGED_ATTACK", "дальник": "DOTA_UNIT_CAP_RANGED_ATTACK","ближник" :"DOTA_UNIT_CAP_MELEE_ATTACK"}
damage_dict = {"средний" : 40, "нет" : 0, "низкий" : 15,"высокий":100}
event_dict = {"спаун":0,"атака":1,"смерть":2,"рядом_враг":4,"урон":5,"никогда":20,"время":3,}

translate_dict = {"легендарный":"legendary","редкий":"rare","обычный":"common","саппорт":"support",
				"особый":"special","дамагер":"dd","танк":"durable","средне":"medium","мало":"small",
				"много":"large","средняя":"medium","медленная":"small","средняя":"medium","нет":"none",
				"низкая":"small","дальник":"ranged","ближник":"melee","средний":"medium","низкий":"small","высокий":"large",
                                "очень мало": "very small", "высокая" : "high"}
#start
main_xml.write(main_xml_template.read())
main_xml.write('''<Panel id="AbilitiesPickScreen">\n''')
npc_abilities_custom.write(npc_abilities_custom_template.read())
npc_units_custom.write('''
#base "npc_mobs_custom.txt"
"DOTAUnits"
{
	"Version"	"1"
''')

addon_russian.write(''' "lang"
{
"Language" "Russian"
"Tokens"
{		
"addon_game_name"   "Line Battle"
"HeroName_npc_dota_hero_axe"					"Tower"
"DOTA_Tooltip_Ability_manaSkill"  				"Mana"  
"DOTA_Tooltip_Ability_manaSkill_Description"  	"это повысит твой мана реген"\n''')
addon_english.write(''' "lang"
{
"Language" "English"
"Tokens"
{		
"addon_game_name"   "Line Battle"
"HeroName_npc_dota_hero_axe"					"Tower"
"DOTA_Tooltip_Ability_manaSkill"  				"Mana"  
"DOTA_Tooltip_Ability_manaSkill_Description"  	"use for increase your mana regen"\n''')
unitsTable.write("addonName_unitIDs_table = {\n") #если менять то не забыть поменять в create_unit
#units       
settings = settings_file.read().split("-")

for setting in settings:
    settingKV = dict(map(str, x.split(maxsplit=1)) for x in setting.split("\n") if x.split(maxsplit=1) != [])
    npc_units_custom.write("\"npc_addonName_"+settingKV["имя"]+"\"\n{\n")
    npc_units_custom.write('''"BaseClass"   "npc_dota_creature"\n''')
    npc_units_custom.write('''"AttackRate"  "1.0"\n''')
    npc_units_custom.write('''"AttackRangeBuffer"   "0"\n''')
    npc_units_custom.write('''"ProjectileSpeed" "900"\n''')
    npc_units_custom.write('''"AttackRangeBuffer"   "0"\n''')
    npc_units_custom.write('''"MovementTurnRate"    "0.5"\n''')
    npc_units_custom.write('''"BoundsHullName"    "DOTA_HULL_SIZE_HUGE"\n''')
    if(settingKV.get("логика") == "сложный"):
        npc_units_custom.write('''"vscripts"   "'''+ settingKV["имя"] + '''.lua"\n''')
    else:
        npc_units_custom.write('''"vscripts"   "unitsCtrl.lua"\n''')
    if(settingKV.get("снаряд") != None):
        npc_units_custom.write('''"ProjectileModel"  "''' + str(settingKV.get("снаряд"))+ '''"\n''') 
    npc_units_custom.write('''"MovementCapabilities"    "DOTA_UNIT_CAP_MOVE_GROUND"''')
    
    npc_units_custom.write('''"Model"   "''' + str(settingKV["модель"]) + "\"\n")   
    npc_units_custom.write('''"StatusHealth"   "''' + str(hp_dict[settingKV["хп"]]) + "\"\n")
    npc_units_custom.write('''"MovementSpeed"   "''' + str(speed_dict[settingKV["скорость"]]) + "\"\n")   
    npc_units_custom.write('''"AttackRange"   "''' + str(dist_dict[settingKV["дальность"]]) + "\"\n")   
    npc_units_custom.write('''"AttackCapabilities"   "''' + str(attack_type_dict[settingKV["тип_атаки"]]) + "\"\n")
    npc_units_custom.write('''"AttackDamageMin"   "''' + str(damage_dict[settingKV["урон"]]) + "\"\n")
    npc_units_custom.write('''"AttackDamageMax"   "''' + str(damage_dict[settingKV["урон"]]) + "\"\n")
    for x in range(1, 4):
        if(settingKV.get("скилл"+str(x)) != None):
            npc_units_custom.write('''"Ability'''+str(x) + "\"\t\"" +settingKV["скилл"+str(x)] + "\"\n")
    if(settingKV.get("одежда"+str(1)) != None):
        npc_units_custom.write('''"Creature"
	    {
			"AttachWearables"
			{\n''')
    for x in range(1, 10):
        if(settingKV.get("одежда"+str(x)) != None):
            npc_units_custom.write('''\t\t\t"Wearable'''+str(x) + '''" { "ItemDef" "''' + settingKV["одежда"+str(x)] + "\"}\n")
    if(settingKV.get("одежда"+str(1)) != None): npc_units_custom.write('''\t\t\t}\n\t\t}\n''')
    npc_units_custom.write("}\n")
#units lang ru
    addon_russian.write('''"DOTA_Tooltip_Ability_'''+settingKV["имя"]+"_create\""+'''  "''' +settingKV["имя"].replace('_',' ') + '''"\n''')
    addon_russian.write('''"DOTA_Tooltip_Ability_'''+settingKV["имя"]+"_create_Description\""+ '''  "
редкость:    '''+"<font color=\'"+colors[rare_colors[settingKV["редкость"]]]+"\'>"+settingKV["редкость"]+"</font><br>" +
'''тип:    '''+ "<font color=\'"+colors[type_colors[settingKV["тип"]]]+"\'>"+settingKV["тип"]+"</font><br>" +
'''хп:     '''+ "<font color=\'"+colors[hp_colors[settingKV["хп"]]]+"\'>"+settingKV["хп"]+"</font><br>" +
'''скорость передвижения:     '''+ "<font color=\'"+colors[speed_colors[settingKV["скорость"]]]+"\'>"+settingKV["скорость"]+"</font><br>" +
'''дальность атаки:     '''+ "<font color=\'"+colors[dist_colors[settingKV["дальность"]]]+"\'>"+settingKV["дальность"]+"</font><br>" +
'''тип атаки:     '''+ "<font color=\'"+colors[attack_type_colors[settingKV["тип_атаки"]]]+"\'>"+settingKV["тип_атаки"]+"</font><br>" +
'''урон:     '''+ "<font color=\'"+colors[damage_colors[settingKV["урон"]]]+"\'>"+settingKV["урон"]+"</font><br>\n" + settingKV["описание"] +"\"\n")
#units lang en так не стоит делать, но мне лень
    addon_english.write('''"DOTA_Tooltip_Ability_'''+settingKV["имя"]+"_create\""+'''  "''' +settingKV["имя"].replace('_',' ') + '''"\n''')
    addon_english.write('''"DOTA_Tooltip_Ability_'''+settingKV["имя"]+"_create_Description\""+ '''  "
rarity:    '''+"<font color=\'"+colors[rare_colors[settingKV["редкость"]]]+"\'>"+translate_dict[settingKV["редкость"]]+"</font><br>" +
'''type:    '''+ "<font color=\'"+colors[type_colors[settingKV["тип"]]]+"\'>"+translate_dict[settingKV["тип"]]+"</font><br>" +
'''hp:     '''+ "<font color=\'"+colors[hp_colors[settingKV["хп"]]]+"\'>"+translate_dict[settingKV["хп"]]+"</font><br>" +
'''speed:     '''+ "<font color=\'"+colors[speed_colors[settingKV["скорость"]]]+"\'>"+translate_dict[settingKV["скорость"]]+"</font><br>" +
'''attack range:     '''+ "<font color=\'"+colors[dist_colors[settingKV["дальность"]]]+"\'>"+translate_dict[settingKV["дальность"]]+"</font><br>" +
'''attack type:     '''+ "<font color=\'"+colors[attack_type_colors[settingKV["тип_атаки"]]]+"\'>"+translate_dict[settingKV["тип_атаки"]]+"</font><br>" +
'''damage:     '''+ "<font color=\'"+colors[damage_colors[settingKV["урон"]]]+"\'>"+translate_dict[settingKV["урон"]]+"</font><br>\n" + settingKV["еописание"] +"\"\n")

#unitsTable
   
    unitsID+=1
    unitsTable.write("["+str(unitsID)+"] = \"npc_addonName_"+settingKV["имя"]+"\",\n")
#unitsCreateAbility

    npc_abilities_custom.write("\""+settingKV["имя"]+"_create\"{\n")
    npc_abilities_custom.write('''
    "BaseClass" "ability_datadriven"
    "AbilityBehavior" "DOTA_ABILITY_BEHAVIOR_NO_TARGET"
    "MaxLevel" "1"\n''')
    npc_abilities_custom.write('''"AbilityTextureName" "addonName_texture_'''+settingKV["имя"]+"\"\n")
    npc_abilities_custom.write('''"AbilityCooldown" "'''+settingKV["кулдаун"]+"\"\n")                   
    npc_abilities_custom.write('''"AbilityManaCost" "'''+settingKV["стоимость"]+"\"\n")
    npc_abilities_custom.write('''"AbilitySpecial"
    {
    "01"
    {
    "var_type" "FIELD_INTEGER"
    "addonName_unitID" "'''+str(unitsID)+"\"\n}\n}")
    npc_abilities_custom.write('''"OnSpellStart"
    {
    "RunScript" 
    {
    "ScriptFile" "create_unit.lua"
    "Function"	"UnitCreate"
    }
    }
    }\n''')
#panorama addSkill
    main_xml.write('''<Button
    class = "PickButton" id="''' + settingKV["имя"]+ "_create\"" +
    ''' onmouseover="DOTAShowAbilityTooltip('''+ settingKV["имя"]+'''_create)" onmouseout="DOTAHideAbilityTooltip()"'''+
    ''' onactivate="onBtnTestClick(\''''+ settingKV["имя"]+ '''_create')"><Image src="file://{resources}/images/addonName_texture_''' + settingKV["имя"]+'''.png"></Image></Button>\n''')
    

main_xml.write('''\t</Panel>\n\t</Panel>\n</root>''')
npc_abilities_custom.write("}")
unitsTable.write("}")
addon_russian.write('''}\n}\n''')
addon_english.write('''}\n}\n''')
npc_units_custom.write("}\n")


npc_abilities_custom.close()
npc_abilities_custom_template.close()
unitsTable.close()
addon_russian.close()
addon_english.close()
npc_units_custom.close()
settings_file.close()
main_xml_template.close()
main_xml.close()
