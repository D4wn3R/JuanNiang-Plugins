local jn = require("jn")

-- 随机数种子
math.randomseed(os.time())

-- ----------------------------------------------------------------------------
-- 回复语料（沿用原插件）
-- ----------------------------------------------------------------------------
local SUCCESS_RESPONSES = {
  "👍{total_likes}", "赞了赞了", "点赞成功！",
  "给{username}点了{total_likes}个赞", "赞送出去啦！一共{total_likes}个哦！",
  "为{username}点赞成功！总共{total_likes}个！", "点了{total_likes}个，快查收吧！",
  "赞已送达，请注意查收~ 一共{total_likes}个！", "给{username}点了{total_likes}个赞，记得回赞哟！",
  "赞了{total_likes}次，看看收到没？", "点了{total_likes}赞，没收到可能是我被风控了",
  "✨ {total_likes}个赞已到账，请查收~", "叮咚！{total_likes}个赞已送达{username}",
  "赞力全开！给{username}送了{total_likes}个赞", "biu~ {total_likes}个赞发射成功！",
  "{username}的赞+{total_likes}，声望提升！", "赞赞赞！一口气点了{total_likes}个",
  "今日份的{total_likes}个赞已安排~", "赞不完，根本赞不完！又点了{total_likes}个",
  "赞气满满！{total_likes}个赞请收好", "赞力觉醒！给{username}狂点{total_likes}个赞",
  "赞到成功！{total_likes}个赞已送达", "赞不绝口！又给{username}点了{total_likes}个",
  "赞力爆棚！今日{total_likes}个赞已送出",
}

local LIMIT_RESPONSES = {
  "今天给{username}的赞已达上限", "赞了那么多还不够吗？", "{username}别太贪心哟~",
  "今天赞过啦！", "今天已经赞过啦~", "已经赞过啦~", "还想要赞？不给了！",
  "已经赞过啦，别再点啦！", "今日赞力已耗尽，明天再来吧~", "{username}今天已经收获满满啦！",
  "赞力不足，请明日再战！", "今日点赞任务已完成✓", "赞力恢复中，请稍后再试",
  "今日份的赞已经给{username}啦", "赞力有限，明天继续哦~", "{username}今天已经被赞爆啦！",
  "赞力CD中，请耐心等待", "今日点赞额度已用完", "赞力值归零，需要重新充能",
  "{username}今天太受欢迎啦！", "赞力过载，系统保护启动", "今日点赞成就已达成！",
}

local ALREADY_SUBSCRIBED_RESPONSES = {
  "你已经自动点赞了哦~", "别急嘛，已经给你自动了~", "自动状态正常，坐等收赞吧！",
  "已经安排上啦，等着收赞吧~", "自动成功，就等时间到啦！", "别重复自动啦，已经在名单里了~",
  "已经在自动名单中啦！", "自动状态：已开启 ✓", "早就给你安排上自动点赞啦~",
  "自动点赞服务运行中...", "已经在自动名单里躺平啦~", "自动状态良好，无需重复操作",
  "早就把你加入自动名单啦！", "自动点赞已激活，无需重复", "已经在自动队列中啦~",
  "自动服务正常运行中", "早就给你设置好啦！", "自动状态：在线等赞",
  "已经在自动名单里啦~", "自动点赞已就绪，等待执行", "早就安排上自动点赞啦！",
  "自动状态：待机中",
}

local SUBSCRIBE_SUCCESS_RESPONSES = {
  "听到了！每天{time}准时给你点赞{count}次~", "安排上了！{time}开始点赞{count}次",
  "搞定！{time}自动点赞{count}次", "已经记住了，{time}执行{count}次",
  "自动设置完成！{time}给你点{count}个赞", "自动成功！坐等{time}收{count}个赞吧",
  "自动点赞已开启！{time}执行{count}次", "设置成功！每天{time}给你送{count}个赞",
  "自动点赞安排妥当！{time}开始{count}次", "已加入日程！{time}自动点赞{count}次",
  "提醒设置成功！{time}点赞{count}次", "自动点赞激活！{time}执行{count}次",
  "成功加入自动名单！{time}点赞{count}次", "自动点赞已部署！{time}开始{count}次",
  "设置完成！{time}自动送{count}个赞", "自动点赞礼包已激活！{time}发放{count}次",
  "未来已安排！{time}点赞{count}次", "自动服务开启！{time}执行{count}次",
  "魔法生效！{time}自动点赞{count}次", "自动点赞马戏团开演！{time}表演{count}次",
  "自动点赞冠军已诞生！{time}执行{count}次", "摇滚起来！{time}自动点赞{count}次",
}

local UNSUBSCRIBE_RESPONSES = {
  "✅ 取消自动成功", "已取消自动，不再给你点赞啦", "取消成功，以后不给你点赞了",
  "已经删除了你的信息哦", "自动已取消，需要时再叫我~", "自动点赞已关闭",
  "取消成功，不再自动点赞", "自动服务已终止", "已退出自动点赞计划",
  "自动锁定已解除", "自动点赞气球已放飞", "自动服务日落西山",
  "自动点赞已停止", "自动服务进入休眠", "自动点赞已关机",
  "已取消自动点赞目标", "自动点赞锚已收起", "自动点赞浪潮已退去",
  "自动点赞马戏团已散场", "自动服务到此结束", "自动点赞竞赛已完结",
  "自动点赞魔法已解除",
}

local NOT_FRIEND_RESPONSES = {
  "自动失败，请先加我为好友哦~", "要先成为好友才能自动点赞呢", "加个好友先吧，不然没法自动",
  "咱们先加个好友呗~", "成为好友才能开启自动服务", "目标锁定失败，请先加好友",
  "好友之门尚未开启", "成为好友，点赞更轻松", "友情提示：请先加为好友",
  "成为好友解锁自动点赞", "好友关系是自动点赞的前提", "加个好友，点赞更精彩",
  "成为好友，开启点赞之旅", "好友认证是自动点赞的钥匙", "魔法提示：请先建立好友关系",
  "摇滚起来！先加个好友吧", "成为好友，争夺点赞冠军", "马戏团规则：先加好友再表演",
  "友情建议：加个好友更方便", "成为好友，点亮自动点赞", "游戏规则：好友才能自动",
  "系统提示：请先添加好友",
}

local BLACKLIST_RESPONSES = {
  "❌ 你在黑名单中，无法使用点赞功能", "🚫 黑名单用户禁止使用本插件",
  "⛔ 抱歉，你在黑名单中，无法点赞", "🔒 黑名单限制，请联系管理员",
  "🚷 禁止访问：你在黑名单中", "⚡ 权限被拒绝：你在黑名单中",
  "🛑 操作被阻止：你在黑名单中", "⏸️ 暂停服务：你在黑名单中",
  "🔐 访问受限：黑名单用户", "🚨 安全警告：黑名单用户禁止操作",
  "🎭 不好意思，你在黑名单中哦", "💢 黑名单用户还想点赞？想得美！",
  "😤 黑名单用户禁止使用此功能", "🚯 黑名单用户请勿操作", "📵 权限不足：黑名单用户",
  "🔞 年龄不够？不，是黑名单！", "🧱 你被墙了，黑名单用户",
  "⚖️ 公正裁决：黑名单用户禁止", "🧯 紧急阻止：黑名单用户操作",
  "🪤 触发陷阱：黑名单用户", "🔨 黑名单用户被锤了", "🗑️ 黑名单用户请左转离开",
}

-- ----------------------------------------------------------------------------
-- 通用工具
-- ----------------------------------------------------------------------------
local function pick(list)
  if type(list) ~= "table" or #list == 0 then return "" end
  return list[math.random(#list)]
end

local function contains(list, v)
  if type(list) ~= "table" then return false end
  for _, x in ipairs(list) do
    if x == v then return true end
  end
  return false
end

local function tonum(v, default)
  local n = tonumber(v)
  if n == nil then return default end
  return n
end

-- jn.config 兜底（文档声明无需权限默认注入，此处防御性处理）
local cfg_api = jn.config
local function cfg(key, default)
  if not cfg_api then return default end
  local v = cfg_api.get(key)
  if v == nil then return default end
  return v
end
local function cfg_bool(key, default)
  local v = cfg(key, nil)
  if v == nil then return default end
  return v
end
local function cfg_list(key)
  local v = cfg(key, {})
  if type(v) ~= "table" then return {} end
  return v
end
local function cfg_num(key, default)
  return tonum(cfg(key, nil), default)
end

-- 剥离 CQ 码（如 [CQ:at,qq=123]），并清理前导空白
-- 场景：群里发 "@机器人 /赞我" → raw_message 是 "[CQ:at,qq=机器人] /赞我"，
-- 引擎命令系统只识别以 "/" 开头且无 @ 前缀的原文，因此 on_message 需自行剥离后分派。
local function strip_cq(raw)
  local cleaned = raw:gsub("%[CQ:[^%]]*%]", "")
  cleaned = cleaned:gsub("^%s+", "")
  return cleaned
end

-- ----------------------------------------------------------------------------
-- 状态持久化（插件目录 data/state.json）
--   存：订阅用户、黑名单、最后点赞日期、自动点赞时间
-- ----------------------------------------------------------------------------
local STATE_FILE = "data/state.json"

local state = {
  subscribed_users = {},
  blacklist_users = {},
  zanwo_date = "2025-01-01",
  schedule = { hour = 9, minute = 0, second = 0 },
}

local function load_state()
  local content, err = jn.file.read(STATE_FILE)
  if err or content == nil or content == "" then
    jn.log.warn("状态文件不存在或为空，使用默认状态")
    return
  end
  local ok, data = pcall(jn.json.decode, content)
  if not ok or type(data) ~= "table" then
    jn.log.error("状态文件解析失败，使用默认状态")
    return
  end
  if type(data.subscribed_users) == "table" then state.subscribed_users = data.subscribed_users end
  if type(data.blacklist_users) == "table" then state.blacklist_users = data.blacklist_users end
  if type(data.zanwo_date) == "string" then state.zanwo_date = data.zanwo_date end
  if type(data.schedule) == "table" then
    state.schedule = {
      hour = tonum(data.schedule.hour, 9),
      minute = tonum(data.schedule.minute, 0),
      second = tonum(data.schedule.second, 0),
    }
  end
  jn.log.info(string.format("状态已加载：订阅 %d 人，黑名单 %d 人，最后点赞 %s",
    #state.subscribed_users, #state.blacklist_users, state.zanwo_date))
end

local function save_state()
  local ok, content = pcall(jn.json.encode, state)
  if not ok then
    jn.log.error("状态序列化失败: " .. tostring(content))
    return
  end
  local ok2, err2 = jn.file.write(STATE_FILE, content)
  if not ok2 then
    jn.log.error("状态保存失败: " .. tostring(err2))
  end
end

-- ----------------------------------------------------------------------------
-- 权限与过滤
-- ----------------------------------------------------------------------------
local function is_admin(event)
  local admins = event.admins
  if type(admins) ~= "table" then return false end
  local uid = tostring(event.user_id)
  for _, a in ipairs(admins) do
    if tostring(a) == uid then return true end
  end
  return false
end

local function is_blacklisted(user_id)
  return contains(state.blacklist_users, tostring(user_id))
end

local function in_allowed_group(event)
  if not cfg_bool("enable_white_list_groups", false) then return true end
  local gid = event.group_id and tostring(event.group_id) or ""
  return contains(cfg_list("white_list_groups"), gid)
end

-- ----------------------------------------------------------------------------
-- 点赞核心
-- ----------------------------------------------------------------------------
-- 单次点赞：分批发送（每次最多 10 个），返回 (实际点赞数, 错误信息)
local function send_likes(user_id, total)
  local sent = 0
  local remaining = tonum(total, 0)
  local last_err = nil
  while remaining > 0 do
    local times = math.min(10, remaining)
    local ok, err = jn.onebot11.send_like(tonumber(user_id), times)
    if ok then
      sent = sent + times
      remaining = remaining - times
    else
      last_err = err or ""
      break
    end
  end
  return sent, last_err
end

local function get_username(user_id)
  local info, err = jn.onebot11.get_stranger_info(tonumber(user_id))
  if not err and info and info.nickname then
    return info.nickname
  end
  return "未知用户"
end

-- 给单个用户点赞，返回回复文案
local function like_single(user_id)
  local per_user = cfg_num("likes_per_user", 20)
  if per_user < 1 then per_user = 20 end
  local sent, err = send_likes(user_id, per_user)
  local username = get_username(user_id)
  if sent > 0 then
    local reply = pick(SUCCESS_RESPONSES)
    reply = reply:gsub("{total_likes}", tostring(sent))
    reply = reply:gsub("{username}", username)
    return reply
  end
  if err then
    local limit_reply = pick(LIMIT_RESPONSES)
    if err:find("已达") then
      return limit_reply:gsub("{username}", username)
    end
    if err:find("权限") then
      return "点赞权限受限，你好像没开陌生人点赞"
    end
    return "点赞失败: " .. err
  end
  return "点赞失败"
end

-- 给多个用户点赞，返回多行回复
local function like_multiple(user_ids)
  local lines = {}
  for _, uid in ipairs(user_ids) do
    table.insert(lines, like_single(uid))
  end
  return table.concat(lines, "\n")
end

-- ----------------------------------------------------------------------------
-- 自动点赞（消息触发式调度 + 可选 CronJob）
-- ----------------------------------------------------------------------------
local function today_str()
  return os.date("%Y-%m-%d")
end

local function auto_time_str()
  local s = state.schedule
  return string.format("%02d:%02d:%02d", s.hour, s.minute, s.second)
end

local function next_like_time()
  local s = state.schedule
  local now = os.time()
  local today = os.date("*t")
  local target = os.time({ year = today.year, month = today.month, day = today.day,
    hour = s.hour, min = s.minute, sec = s.second })
  if now < target then
    return os.date("%Y年%m月%d日 %H:%M:%S", target)
  end
  local tomorrow = os.time({ year = today.year, month = today.month, day = today.day + 1,
    hour = s.hour, min = s.minute, sec = s.second })
  return os.date("%Y年%m月%d日 %H:%M:%S", tomorrow)
end

local function send_notifications(message)
  local groups = cfg_list("notify_groups")
  for _, g in ipairs(groups) do
    local gid = tonum(g, nil)
    if gid then
      jn.onebot11.send_group_msg(gid, message)
    end
  end
end

-- 获取好友 ID 列表；失败返回 nil
local function get_friend_ids()
  local list, err = jn.onebot11.get_friend_list()
  if err then return nil end
  local ids = {}
  for _, f in ipairs(list or {}) do
    table.insert(ids, tostring(f.user_id))
  end
  return ids
end

-- 过滤出有效订阅用户：在好友列表且不在黑名单
local function valid_subscribed_users(friend_ids)
  local valid = {}
  for _, uid in ipairs(state.subscribed_users) do
    if contains(friend_ids, uid) and not is_blacklisted(uid) then
      table.insert(valid, uid)
    end
  end
  return valid
end

local function execute_auto_like()
  local today = today_str()
  if state.zanwo_date == today then
    jn.log.info("今天已经点赞过，跳过执行")
    return
  end
  if #state.subscribed_users == 0 then
    jn.log.warn("没有订阅用户，跳过执行")
    return
  end

  local friend_ids = get_friend_ids()
  if not friend_ids then
    jn.log.error("获取好友列表失败，本次自动点赞跳过（不更新日期）")
    send_notifications("❌ 自动点赞执行失败\n💡 获取好友列表失败")
    return
  end

  local valid = valid_subscribed_users(friend_ids)
  if #valid == 0 then
    state.zanwo_date = today
    save_state()
    jn.log.warn("没有有效的好友订阅用户（或全部在黑名单），已标记今日完成")
    return
  end

  local now_str = os.date("%Y年%m月%d日 %H:%M:%S")
  local per_user = cfg_num("likes_per_user", 20)
  send_notifications("🤖 开始执行自动点赞\n⏰ 时间: " .. now_str ..
    "\n👥 目标用户: " .. #valid .. " 人\n🔢 每人点赞: " .. per_user .. " 次")

  local result = like_multiple(valid)

  state.zanwo_date = today
  save_state()

  send_notifications("✅ 自动点赞执行完成\n⏰ 时间: " .. now_str ..
    "\n👥 成功点赞: " .. #valid .. " 人\n🔢 每人点赞: " .. per_user ..
    " 次\n⏳ 下次点赞: " .. next_like_time())
  jn.log.info("自动点赞执行完成，目标 " .. #valid .. " 人")
end

-- 消息触发式检查：当前时间到达设定时间且今天未点赞则执行
local function check_daily_like()
  if not cfg_bool("auto_like_enabled", true) then return end
  local s = state.schedule
  local now = os.time()
  local today = os.date("*t")
  local target = os.time({ year = today.year, month = today.month, day = today.day,
    hour = s.hour, min = s.minute, sec = s.second })
  if now >= target and state.zanwo_date ~= today_str() then
    local ok, err = pcall(execute_auto_like)
    if not ok then
      jn.log.error("自动点赞执行失败: " .. tostring(err))
      send_notifications("❌ 自动点赞执行失败\n💡 " .. tostring(err))
    end
  end
end

-- ----------------------------------------------------------------------------
-- 各功能处理器（命令与文本指令共用）
-- ----------------------------------------------------------------------------
local function handle_like_me(event)
  local uid = tostring(event.user_id)
  if is_blacklisted(uid) then
    return pick(BLACKLIST_RESPONSES)
  end
  if not in_allowed_group(event) then
    return nil -- 白名单外，静默忽略
  end
  return like_single(uid)
end

local function handle_subscribe(event)
  local uid = tostring(event.user_id)
  if is_blacklisted(uid) then
    return pick(BLACKLIST_RESPONSES)
  end
  if not in_allowed_group(event) then
    return nil
  end
  local friend_ids = get_friend_ids()
  if not friend_ids or not contains(friend_ids, uid) then
    return pick(NOT_FRIEND_RESPONSES)
  end
  if contains(state.subscribed_users, uid) then
    return pick(ALREADY_SUBSCRIBED_RESPONSES)
  end
  table.insert(state.subscribed_users, uid)
  save_state()
  local reply = pick(SUBSCRIBE_SUCCESS_RESPONSES)
  reply = reply:gsub("{time}", auto_time_str())
  reply = reply:gsub("{count}", tostring(cfg_num("likes_per_user", 20)))
  jn.log.info("用户 " .. uid .. " 开启了自动点赞")
  return reply
end

local function handle_unsubscribe(event)
  local uid = tostring(event.user_id)
  if not contains(state.subscribed_users, uid) then
    return "你还没有开启自动点赞哦~"
  end
  for i, v in ipairs(state.subscribed_users) do
    if v == uid then
      table.remove(state.subscribed_users, i)
      break
    end
  end
  save_state()
  jn.log.info("用户 " .. uid .. " 取消了自动点赞")
  return pick(UNSUBSCRIBE_RESPONSES)
end

local function handle_add_blacklist(event, args)
  if not is_admin(event) then return "❌ 权限不足：仅管理员可操作" end
  local qq = args and args[1]
  if not qq or not tostring(qq):match("^%d+$") then
    return "❌ 格式错误\n💡 请输入正确的QQ号"
  end
  qq = tostring(qq)
  if contains(state.blacklist_users, qq) then
    return "❌ 用户 " .. qq .. " 已在黑名单中"
  end
  table.insert(state.blacklist_users, qq)
  -- 自动取消该用户的订阅
  for i, v in ipairs(state.subscribed_users) do
    if v == qq then
      table.remove(state.subscribed_users, i)
      break
    end
  end
  save_state()
  jn.log.info("管理员将用户 " .. qq .. " 加入黑名单")
  return "✅ 已添加用户 " .. qq .. " 到黑名单\n⚠️ 已自动取消该用户的自动点赞"
end

local function handle_remove_blacklist(event, args)
  if not is_admin(event) then return "❌ 权限不足：仅管理员可操作" end
  local qq = args and args[1]
  if not qq or not tostring(qq):match("^%d+$") then
    return "❌ 格式错误\n💡 请输入正确的QQ号"
  end
  qq = tostring(qq)
  if not contains(state.blacklist_users, qq) then
    return "❌ 用户 " .. qq .. " 不在黑名单中"
  end
  for i, v in ipairs(state.blacklist_users) do
    if v == qq then
      table.remove(state.blacklist_users, i)
      break
    end
  end
  save_state()
  jn.log.info("管理员将用户 " .. qq .. " 移出黑名单")
  return "✅ 已从黑名单移除用户 " .. qq
end

local function handle_view_blacklist(event)
  if not is_admin(event) then return "❌ 权限不足：仅管理员可操作" end
  if #state.blacklist_users == 0 then
    return "📝 黑名单当前为空"
  end
  local lines = {}
  for _, uid in ipairs(state.blacklist_users) do
    table.insert(lines, "• " .. uid)
  end
  return "📋 黑名单用户列表（共 " .. #state.blacklist_users .. " 人）：\n" .. table.concat(lines, "\n")
end

local function handle_set_time(event, args)
  if not is_admin(event) then return "❌ 权限不足：仅管理员可操作" end
  local time_str = (args and args[1]) or ""
  local hour, minute, second

  local hh, mm, ss = string.match(time_str, "^(%d+):(%d+):(%d+)$")
  if hh then
    hour, minute, second = tonumber(hh), tonumber(mm), tonumber(ss)
  else
    local h2, m2 = string.match(time_str, "^(%d+):(%d+)$")
    if h2 then
      hour, minute, second = tonumber(h2), tonumber(m2), 0
    else
      local h3 = tonumber(time_str)
      if h3 == nil then
        return "❌ 设置失败\n💡 时间格式错误，请使用 HH:MM:SS 格式\n💡 例如: 15:30:00 或 15:30 或 15"
      end
      hour, minute, second = h3, 0, 0
    end
  end

  if hour < 0 or hour > 23 then return "❌ 设置失败\n💡 小时必须在 0-23 之间" end
  if minute < 0 or minute > 59 then return "❌ 设置失败\n💡 分钟必须在 0-59 之间" end
  if second < 0 or second > 59 then return "❌ 设置失败\n💡 秒数必须在 0-59 之间" end

  local old = auto_time_str()
  state.schedule = { hour = hour, minute = minute, second = second }

  local date_msg
  if state.zanwo_date == today_str() then
    local old_date = state.zanwo_date
    local yesterday = os.date("%Y-%m-%d", os.time() - 86400)
    state.zanwo_date = yesterday
    date_msg = "\n📅 点赞日期已重置: " .. old_date .. " → " .. yesterday
  else
    date_msg = "\n📅 点赞日期保持不变: " .. state.zanwo_date
  end
  save_state()

  jn.log.info("设置自动点赞时间: " .. old .. " -> " .. time_str)
  return "✅ 时间设置成功\n⏰ 自动点赞时间: " .. old .. " → " .. auto_time_str() ..
    date_msg .. "\n⏳ 下次点赞: " .. next_like_time()
end

local function handle_immediate_like(event)
  if not is_admin(event) then return "❌ 权限不足：仅管理员可操作" end
  local reset_msg = ""
  if state.zanwo_date == today_str() then
    state.zanwo_date = os.date("%Y-%m-%d", os.time() - 86400)
    reset_msg = "🔄 检测到今天已点赞过，自动重置日期后继续执行...\n"
  end
  if #state.subscribed_users == 0 then
    return "❌ 没有自动用户"
  end
  local friend_ids = get_friend_ids()
  if not friend_ids then
    return "❌ 获取好友列表失败"
  end
  local valid = valid_subscribed_users(friend_ids)
  if #valid == 0 then
    return "❌ 没有找到自动的好友用户或所有用户都在黑名单中"
  end
  local result = like_multiple(valid)
  state.zanwo_date = today_str()
  save_state()
  return reset_msg .. "✅ 立即点赞完成\n👥 成功点赞: " .. #valid .. " 人\n" .. result
end

local function handle_status(event)
  if not is_admin(event) then return "❌ 权限不足：仅管理员可操作" end
  local enabled = cfg_bool("auto_like_enabled", true)
  return "🤖 点赞插件状态\n" ..
    "⏰ 自动点赞时间: " .. auto_time_str() .. "\n" ..
    "⏳ 下次点赞: " .. next_like_time() .. "\n" ..
    "📅 最后点赞日期: " .. state.zanwo_date .. "\n" ..
    "🔢 每人点赞: " .. cfg_num("likes_per_user", 20) .. " 次\n" ..
    "✅ 自动点赞: " .. (enabled and "已开启" or "已关闭") .. "\n" ..
    "👥 自动用户: " .. #state.subscribed_users .. " 人\n" ..
    "🚫 黑名单用户: " .. #state.blacklist_users .. " 人\n" ..
    "📢 通知群组: " .. #cfg_list("notify_groups") .. " 个"
end

local function handle_debug(event)
  if not is_admin(event) then return "❌ 权限不足：仅管理员可操作" end
  local today = today_str()
  local enabled = cfg_bool("auto_like_enabled", true)
  local should_auto = enabled and #state.subscribed_users > 0 and state.zanwo_date ~= today
  return "🔍 调试信息\n" ..
    "当前时间: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n" ..
    "设置时间: " .. auto_time_str() .. "\n" ..
    "最后点赞日期: " .. state.zanwo_date .. "\n" ..
    "今天日期: " .. today .. "\n" ..
    "日期不同: " .. tostring(state.zanwo_date ~= today) .. "\n" ..
    "自动点赞启用: " .. tostring(enabled) .. "\n" ..
    "自动用户数: " .. #state.subscribed_users .. "\n" ..
    "黑名单用户数: " .. #state.blacklist_users .. "\n" ..
    "通知群组: " .. #cfg_list("notify_groups") .. "\n" ..
    "满足自动点赞条件: " .. tostring(should_auto) .. "\n" ..
    "下次点赞: " .. next_like_time()
end

-- ----------------------------------------------------------------------------
-- 命令注册（带斜杠：/赞我、/自动点赞 ...）
-- ----------------------------------------------------------------------------
local function reg_cmd(path, handler, description, usage)
  jn.command.register(path, function(args, event)
    local reply = handler(event, args)
    if reply == nil then
      return true, nil -- 静默消费，不进 Agent
    end
    return true, reply
  end, { description = description, usage = usage })
end

reg_cmd("赞我", function(event) return handle_like_me(event) end,
  "立即为我点赞", "/赞我")
reg_cmd("自动点赞", function(event) return handle_subscribe(event) end,
  "订阅每日自动点赞（需为好友）", "/自动点赞")
reg_cmd("取消自动点赞", function(event) return handle_unsubscribe(event) end,
  "取消每日自动点赞", "/取消自动点赞")
reg_cmd("添加黑名单", function(event, args) return handle_add_blacklist(event, args) end,
  "将用户加入黑名单（管理员）", "/添加黑名单 <QQ号>")
reg_cmd("移除黑名单", function(event, args) return handle_remove_blacklist(event, args) end,
  "将用户移出黑名单（管理员）", "/移除黑名单 <QQ号>")
reg_cmd("查看黑名单", function(event) return handle_view_blacklist(event) end,
  "查看黑名单列表（管理员）", "/查看黑名单")
reg_cmd("设置点赞时间", function(event, args) return handle_set_time(event, args) end,
  "设置每日自动点赞时间（管理员）", "/设置点赞时间 <HH:MM:SS>")
reg_cmd("立即点赞", function(event) return handle_immediate_like(event) end,
  "立即执行一次自动点赞（管理员，测试用）", "/立即点赞")
reg_cmd("点赞状态", function(event) return handle_status(event) end,
  "查看点赞插件状态（管理员）", "/点赞状态")
reg_cmd("调试信息", function(event) return handle_debug(event) end,
  "查看详细调试信息（管理员）", "/调试信息")

-- 按消息渠道回复（群聊发群、私聊发私聊）
local function reply_in_channel(event, text)
  if not text then return end
  if event.message_type == "group" and event.group_id then
    jn.onebot11.send_group_msg(event.group_id, text)
  else
    jn.onebot11.send_private_msg(event.user_id, text)
  end
end

-- ----------------------------------------------------------------------------
-- on_message 文本命令分派（支持 @机器人 + 命令 / 纯文本命令）
-- 注意：引擎命令系统只处理以 "/" 开头的 raw_message；
-- 带 @ 的消息 raw_message 以 CQ 码开头，进不到命令系统，只能在此分派。
-- ----------------------------------------------------------------------------
-- 不带参数的命令表（纯文本路径 → 处理器）
local TEXT_COMMANDS = {
  ["赞我"] = function(event) return handle_like_me(event) end,
  ["自动点赞"] = function(event) return handle_subscribe(event) end,
  ["取消自动点赞"] = function(event) return handle_unsubscribe(event) end,
  ["查看黑名单"] = function(event) return handle_view_blacklist(event) end,
  ["立即点赞"] = function(event) return handle_immediate_like(event) end,
  ["点赞状态"] = function(event) return handle_status(event) end,
  ["调试信息"] = function(event) return handle_debug(event) end,
}

-- 根据剥离后的干净文本分派命令；返回 (consumed, reply)
local function dispatch_text_command(event, clean)
  local text = clean
  if text:sub(1, 1) == "/" then
    text = text:sub(2)
    text = text:gsub("^%s+", "")
  end
  if text == "" then return false, nil end

  -- 无参数命令
  local handler = TEXT_COMMANDS[text]
  if handler then
    return true, handler(event)
  end

  -- 带参数命令：添加黑名单 / 移除黑名单 / 设置点赞时间
  local qq = text:match("^添加黑名单%s+(%S+)")
  if qq then return true, handle_add_blacklist(event, { qq }) end
  qq = text:match("^移除黑名单%s+(%S+)")
  if qq then return true, handle_remove_blacklist(event, { qq }) end
  local t = text:match("^设置点赞时间%s+(%S+)")
  if t then return true, handle_set_time(event, { t }) end

  return false, nil
end

-- ----------------------------------------------------------------------------
-- 消息事件：兼容无斜杠文本指令 + @机器人 + 触发每日自动点赞检查
-- 返回 (consumed, skip_reply)：consumed=true 表示消息不进 Agent
-- ----------------------------------------------------------------------------
function on_message(event)
  -- 任意消息到达时检查每日自动点赞
  check_daily_like()

  local raw = event.raw_message or ""
  if raw == "" then return false, false end

  -- 如果消息以 "/" 开头，引擎命令系统已处理（命中即短路），此处不再重复
  if raw:sub(1, 1) == "/" then return false, false end

  -- 剥离 CQ 码（@机器人 等）后按文本命令分派
  local clean = strip_cq(raw)
  if clean == "" then return false, false end

  local consumed, reply = dispatch_text_command(event, clean)
  if consumed then
    reply_in_channel(event, reply)
    return true, false
  end

  return false, false
end

-- ----------------------------------------------------------------------------
-- 定时任务回调：可在 Web 面板为本插件创建 CronJob 定时触发自动点赞
-- 消息触发式调度已覆盖日常场景；此回调用于可靠准点触发（幂等，重复触发无害）
-- ----------------------------------------------------------------------------
function on_cronjob(event)
  jn.log.info("收到 CronJob 触发，检查自动点赞")
  local ok, err = pcall(check_daily_like)
  if not ok then
    jn.log.error("CronJob 触发自动点赞检查失败: " .. tostring(err))
  end
end

-- ----------------------------------------------------------------------------
-- 加载时：读取状态 + 若已过设定时间且今天未点赞则立即执行
-- ----------------------------------------------------------------------------
load_state()
local ok_init, err_init = pcall(check_daily_like)
if not ok_init then
  jn.log.error("启动时自动点赞检查失败: " .. tostring(err_init))
end

jn.log.info("爱点赞插件加载完成（移植自 astrbot_plugin_furry_zan v1.3.0）")
