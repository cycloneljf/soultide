--技能树参考 官方源码——skilltree_willow.lua skilltree_defs skilltreedata skilltreeupdator(component)
--关于tex 安装python 和 PIL库 在VScode自己写一个转化程序（no） 直接用别人的xml（yes）
--其实XML能看懂自己写也可以 XML是HTML经过facebook开发之后的一种更好的超文本链接语言 幸好我学过一点前端


local UI_LEFT, UI_RIGHT = -214, 228
local UI_VERTICAL_MIDDLE = (UI_LEFT + UI_RIGHT) * 0.5
local UI_TOP, UI_BOTTOM = 176, 20
local TILE_SIZE, TILE_HALFSIZE = 34, 16
local BASELEFT = -200
local LEAP = 40
local SKILLTREESTRINGS = STRINGS.SKILLTREE.FRISIA

local ORDERS =
{
	{"skill_up", {-214 + 18, 176 + 30}},
	{"soulcore", 	{-62, 176 + 30}},
	{"soulcore_potential", {66 + 18, 176 + 30}},
	{"live_workeffi",{204, 176 + 30}},
    {"soultide_sp", {204, 176 + 30}},
    -- {"exceed", {204, 176 + 30}},

}


local function BuildSkillsData(SkillTreeFns)
    local skills = {
		frisia_skillup_i = {
			title = SKILLTREESTRINGS.SKILLUP_I_TITLE,
			desc = SKILLTREESTRINGS.SKILLUP_I_DESC,
			icon = "frisia_skillup_i",
			pos = {-214, 36},
			root = true, --根节点 
			defaultfocus = true,
			group = "skill_up",
			tags = {"frisia_skill","skill_up","frisia_skill_root"},
			connects = { --由根节点到子节点
				"frisia_skillup_ii"
			},
		},

        frisia_skillup_ii = {
			title = SKILLTREESTRINGS.SKILLUP_II_TITLE,
			desc = SKILLTREESTRINGS.SKILLUP_II_DESC,
			icon = "frisia_skillup_ii",
			pos = {-214, 36 + LEAP},
			root = false,
			group = "skill_up",
			tags = {"frisia_skill","skill_up"},
			-- locks = {"frisia_skillup_ii_lock",
			-- },
			connects = {
				"frisia_skillup_iii",
				"frisia_live_workeffi_i"
			},
		},

        frisia_skillup_iii = {
			title = SKILLTREESTRINGS.SKILLUP_III_TITLE,
			desc = SKILLTREESTRINGS.SKILLUP_III_DESC,
			icon = "frisia_skillup_iii",
			pos = {-214, 36 + 2*LEAP},
			root = false,
			group = "skill_up",
			tags = {"frisia_skill","skill_up"},
			-- locks = {"frisia_skillup_iii_lock",
			-- },
			connects = {
				"frisia_skillup_iv",
				"frisia_soultide_sp_i"
			},
		},

        frisia_skillup_iv = {
			title = SKILLTREESTRINGS.SKILLUP_IV_TITLE,
			desc = SKILLTREESTRINGS.SKILLUP_IV_DESC,
			icon = "frisia_skillup_iv",
			pos = {-214, 36 + 3 * LEAP},
			root = false,
			group = "skill_up",
			tags = {"frisia_skill","skill_up"},
			-- locks = {"frisia_skillup_iv_lock",
			-- },
			connects = {		
                "frisia_soulcore_i"
			},
		},

        frisia_soulcore_i = {
			title = SKILLTREESTRINGS.SOULCORE_I_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_I_DESC,
			icon = "frisia_soulcore_i",
			pos = {BASELEFT + LEAP, 36 + 4*LEAP},
			root = false,
			group = "soulcore",
			tags = {"frisia_skill","soulcore"},
			connects = {		
                "frisia_soulcore_ii",
				"frisia_soulcore_potential_i"
			},

		},

		frisia_soulcore_ii = {
			title = SKILLTREESTRINGS.SOULCORE_II_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_II_DESC,
			icon = "frisia_soulcore_ii",
			pos = {BASELEFT + 2 *LEAP, 36 + 4*LEAP},
			root = false,
			group = "soulcore",
			tags = {"frisia_skill","soulcore"},
			connects = {		
                "frisia_soulcore_iii",
				"frisia_soulcore_potential_ii"
			},
		},

		frisia_soulcore_iii = {
			title = SKILLTREESTRINGS.SOULCORE_III_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_III_DESC,
			icon = "frisia_soulcore_iii",
			pos = {BASELEFT + 3 *LEAP, 36 + 4*LEAP},
			root = false,
			group = "soulcore",
			tags = {"frisia_skill","soulcore"},
			connects = {		
                "frisia_soulcore_iv",
				"frisia_soulcore_potential_iii"
			},
		},

		frisia_soulcore_iv = {
			title = SKILLTREESTRINGS.SOULCORE_IV_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_IV_DESC,
			icon = "frisia_soulcore_iv",
			pos = {BASELEFT + 4 *LEAP, 36 + 4*LEAP},
			root = false,
			group = "soulcore",
			tags = {"frisia_skill","soulcore"},
			connects = {		
                "frisia_soulcore_v",
				"frisia_soulcore_potential_iv"
			},
		},

		frisia_soulcore_v = {
			title = SKILLTREESTRINGS.SOULCORE_V_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_V_DESC,
			icon = "frisia_soulcore_v",
			pos = {BASELEFT + 5 *LEAP, 36 + 4*LEAP},
			root = false,
			group = "soulcore",
			tags = {"frisia_skill","soulcore"},
			connects = {
				"frisia_soulcore_potential_v"
			},
		},

		frisia_soulcore_potential_i = {
			title = SKILLTREESTRINGS.SOULCORE_POTENTIAL_I_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_POTENTIAL_I_DESC,
			icon = "frisia_soulcore_potential_i",
			pos = {BASELEFT + LEAP, 36 + 3*LEAP},
			root = false,
			group = "soulcore_potential",
			tags = {"frisia_skill","soulcore_potential"},

		},

		frisia_soulcore_potential_ii = {
			title = SKILLTREESTRINGS.SOULCORE_POTENTIAL_II_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_POTENTIAL_II_DESC,
			icon = "frisia_soulcore_potential_ii",
			pos = {BASELEFT + 2 *LEAP, 36 + 3*LEAP},
			root = false,
			group = "soulcore_potential",
			tags = {"frisia_skill","soulcore_potential"},

		},

		frisia_soulcore_potential_iii = {
			title = SKILLTREESTRINGS.SOULCORE_POTENTIAL_III_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_POTENTIAL_III_DESC,
			icon = "frisia_soulcore_potential_iii",
			pos = {BASELEFT + 3 *LEAP, 36 + 3*LEAP},
			root = false,
			group = "soulcore_potential",
			tags = {"frisia_skill","soulcore_potential"},

		},

		frisia_soulcore_potential_iv = {
			title = SKILLTREESTRINGS.SOULCORE_POTENTIAL_IV_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_POTENTIAL_IV_DESC,
			icon = "frisia_soulcore_potential_iv",
			pos = {BASELEFT + 4 *LEAP, 36 + 3*LEAP},
			root = false,
			group = "soulcore_potential",
			tags = {"frisia_skill","soulcore_potential"},

		},

		frisia_soulcore_potential_v = {
			title = SKILLTREESTRINGS.SOULCORE_POTENTIAL_V_TITLE,
			desc = SKILLTREESTRINGS.SOULCORE_POTENTIAL_V_DESC,
			icon = "frisia_soulcore_potential_v",
			pos = {BASELEFT + 5 *LEAP, 36 + 3*LEAP},
			root = false,
			group = "soulcore_potential",
			tags = {"frisia_skill","soulcore_potential"},
		},

		frisia_soultide_sp_i = {
			title = SKILLTREESTRINGS.SOULTIDE_SP_I_TITLE,
			desc = SKILLTREESTRINGS.SOULTIDE_SP_I_DESC,
			icon = "frisia_soultide_sp_i",
			pos = {BASELEFT + 3 *LEAP, 36 + 2*LEAP},
			group = "soultide_sp",
			tags = {"frisia_skill","soultide_sp"},
			connects = {
				"frisia_soultide_sp_ii"
			},
		},

		frisia_soultide_sp_ii = {
			title = SKILLTREESTRINGS.SOULTIDE_SP_II_TITLE,
			desc = SKILLTREESTRINGS.SOULTIDE_SP_II_DESC,
			icon = "frisia_soultide_sp_ii",
			pos = {BASELEFT + 4 *LEAP, 36 + 2*LEAP},
			group = "soultide_sp",
			tags = {"frisia_skill","soultide_sp"},
			connects = {
				"frisia_soultide_sp_iii"
			},
		},

		frisia_soultide_sp_iii = {
			title = SKILLTREESTRINGS.SOULTIDE_SP_III_TITLE,
			desc = SKILLTREESTRINGS.SOULTIDE_SP_III_DESC,
			icon = "frisia_soultide_sp_iii",
			pos = {BASELEFT + 5 *LEAP, 36 + 2*LEAP},
			group = "soultide_sp",
			tags = {"frisia_skill","soultide_sp"},
		},

		frisia_live_workeffi_i = {
			title = SKILLTREESTRINGS.LIVE_WORKEFFI_I_TITLE,
			desc = SKILLTREESTRINGS.LIVE_WORKEFFI_I_DESC,
			icon = "frisia_live_workeffi_i",
			pos = {BASELEFT + 4 *LEAP, 36 + 1*LEAP},
			group ="live_workeffi",
			tags = {"frisia_skill","live_workeffi"},
			connects = {"frisia_live_workeffi_ii"}

		},

		frisia_live_workeffi_ii = {
			title = SKILLTREESTRINGS.LIVE_WORKEFFI_II_TITLE,
			desc = SKILLTREESTRINGS.LIVE_WORKEFFI_II_DESC,
			icon = "frisia_live_workeffi_ii",
			pos = {BASELEFT + 5 *LEAP, 36 + 1*LEAP},
			group = "live_workeffi",
			tags = {"frisia_skill","live_workeffi"},

		}
    }



return {
	SKILLS = skills,
	ORDERS = ORDERS,
}
end

return BuildSkillsData