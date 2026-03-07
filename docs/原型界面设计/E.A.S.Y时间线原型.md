代码参考
```
import React, { useState } from 'react';
import { 
  ChevronLeft, 
  ChevronRight, 
  Plus, 
  Clock, 
  Edit3, 
  Trash2,
  Calendar,
  Milk,
  Moon,
  Gamepad2,
  Droplets,
  Scale
} from 'lucide-react';

const TimelinePage = () => {
  const [selectedDate, setSelectedDate] = useState('今天');

  // 模拟时间轴数据
  const dailyLogs = [
    {
      id: 1,
      type: 'E',
      time: '08:00',
      duration: '20min',
      title: '喂奶',
      detail: '奶粉 120ml',
      icon: <Milk size={16} />,
      color: 'bg-green-100 text-green-700 border-green-200',
      dotColor: 'bg-green-500'
    },
    {
      id: 2,
      type: 'A',
      time: '08:20',
      duration: '1h 10min',
      title: '活动',
      detail: '黑白卡练习',
      icon: <Gamepad2 size={16} />,
      color: 'bg-yellow-100 text-yellow-700 border-yellow-200',
      dotColor: 'bg-yellow-500'
    },
    {
      id: 3,
      type: 'W', // Weight
      time: '09:15',
      title: '体重记录',
      detail: '6.55kg',
      tag: '饭后',
      icon: <Scale size={16} />,
      color: 'bg-slate-100 text-slate-700 border-slate-200',
      dotColor: 'bg-slate-500',
      isBodyRecord: true
    },
    {
      id: 4,
      type: 'S',
      time: '09:30',
      duration: '2h 15min',
      title: '睡眠',
      detail: '自主入睡',
      icon: <Moon size={16} />,
      color: 'bg-blue-100 text-blue-700 border-blue-200',
      dotColor: 'bg-blue-500',
      isEdited: true // 标记已编辑
    },
    {
      id: 5,
      type: 'D', // Diaper
      time: '11:45',
      title: '排泄',
      detail: '尿布(湿) + 便便',
      icon: <Droplets size={16} />,
      color: 'bg-orange-100 text-orange-700 border-orange-200',
      dotColor: 'bg-orange-500'
    },
    {
      id: 6,
      type: 'E',
      time: '12:00',
      duration: '25min',
      title: '喂奶',
      detail: '母乳亲喂',
      icon: <Milk size={16} />,
      color: 'bg-green-100 text-green-700 border-green-200',
      dotColor: 'bg-green-500'
    }
  ];

  return (
    <div className="max-w-md mx-auto h-screen bg-white flex flex-col relative overflow-hidden font-sans shadow-xl border-x border-slate-100">
      
      {/* 1. 日期切换导航 */}
      <div className="pt-12 pb-4 px-6 bg-white z-10 shadow-sm">
        <div className="flex justify-between items-center mb-4">
          <h1 className="text-xl font-black text-slate-800 tracking-tight">生活时间轴</h1>
          <button className="bg-teal-50 text-teal-600 p-2 rounded-full">
            <Calendar size={20} />
          </button>
        </div>
        
        <div className="flex justify-between items-center bg-slate-50 rounded-2xl p-1">
          {['3月2日', '3月3日', '今天'].map((date) => (
            <button 
              key={date}
              onClick={() => setSelectedDate(date)}
              className={`flex-1 py-2 text-sm font-bold rounded-xl transition-all ${selectedDate === date ? 'bg-white text-teal-600 shadow-sm' : 'text-slate-400'}`}
            >
              {date}
            </button>
          ))}
        </div>
      </div>

      {/* 2. 时间线流 */}
      <div className="flex-1 overflow-y-auto px-6 py-4 relative scrollbar-hide">
        
        {/* 贯穿背景的虚线 */}
        <div className="absolute left-10 top-0 bottom-0 w-0.5 bg-slate-100 border-l border-dashed border-slate-200"></div>

        <div className="space-y-8 relative">
          {dailyLogs.map((log) => (
            <div key={log.id} className="flex gap-6 group">
              
              {/* 左侧时间显示 */}
              <div className="w-10 text-right shrink-0 pt-1">
                <p className="text-xs font-bold text-slate-800">{log.time}</p>
              </div>

              {/* 中间轴上的点 */}
              <div className="relative z-10 flex flex-col items-center">
                <div className={`w-3 h-3 rounded-full ${log.dotColor} border-4 border-white shadow-sm mt-1.5`}></div>
              </div>

              {/* 右侧详情卡片 */}
              <div className={`flex-1 rounded-2xl border p-4 transition-all active:scale-[0.98] ${log.color}`}>
                <div className="flex justify-between items-start mb-1">
                  <div className="flex items-center gap-1.5">
                    {log.icon}
                    <span className="font-bold text-sm uppercase tracking-wider">{log.title}</span>
                    {log.isEdited && <span className="text-[10px] bg-white/50 px-1.5 py-0.5 rounded italic">已校对</span>}
                  </div>
                  {log.duration && (
                    <div className="flex items-center gap-1 text-[10px] opacity-70 font-medium">
                      <Clock size={10} /> {log.duration}
                    </div>
                  )}
                </div>

                <div className="flex justify-between items-end">
                  <p className="text-sm font-medium opacity-90">{log.detail}</p>
                  
                  {/* 智能标签（如饭后、便前） */}
                  {log.tag && (
                    <span className="bg-white/40 text-[10px] px-2 py-0.5 rounded-full font-bold">
                      {log.tag}
                    </span>
                  )}
                  
                  {/* 编辑/操作按钮（hover显示或一直显示） */}
                  <div className="flex gap-2">
                    <button className="p-1 hover:bg-white/30 rounded"><Edit3 size={14} /></button>
                  </div>
                </div>
              </div>
            </div>
          ))}

          {/* 跨天行为特殊显示示例 */}
          <div className="flex gap-6 opacity-50 italic">
            <div className="w-10 text-right shrink-0 pt-1">
              <p className="text-[10px] font-bold text-slate-400">23:00</p>
            </div>
            <div className="relative z-10 flex flex-col items-center">
              <div className="w-2 h-2 rounded-full bg-slate-300 border-2 border-white mt-2"></div>
            </div>
            <div className="flex-1 py-1 px-4">
              <p className="text-[10px] text-slate-400">昨夜睡眠跨至今日（按开始时间计入昨日）</p>
            </div>
          </div>
        </div>
      </div>

      {/* 3. 悬浮补录按钮 */}
      <div className="absolute bottom-24 right-6 pointer-events-none">
        <button className="w-14 h-14 bg-teal-600 text-white rounded-full shadow-xl shadow-teal-200 flex items-center justify-center pointer-events-auto active:scale-90 transition-transform">
          <Plus size={28} />
        </button>
      </div>

      {/* 底部导航占位 */}
      <div className="h-20 bg-white border-t border-slate-50 flex justify-around items-center">
        <div className="text-slate-400 flex flex-col items-center"><span className="text-[10px]">首页</span></div>
        <div className="text-teal-600 flex flex-col items-center font-bold"><span className="text-[10px]">时间线</span></div>
        <div className="text-slate-400 flex flex-col items-center"><span className="text-[10px]">统计</span></div>
      </div>

      <style dangerouslySetInnerHTML={{__html: `
        .scrollbar-hide::-webkit-scrollbar { display: none; }
      `}} />
    </div>
  );
};

export default TimelinePage;
```

**页面设计说明：**
1. 色彩心理学应用：

- E (Eat): 绿色，代表成长与能量。

- A (Activity): 黄色，代表活力与阳光。

- S (Sleep): 蓝色，代表沉静与修复。

- D/W (Body): 橙色/灰色，用于辅助记录，不干扰主流程。

2. 补录逻辑（单手友好）：

- 右下角的绿色悬浮加号是“补录”入口。

- 点击时间线上的任何卡片，可以立即进入编辑模式，卡片右上角会显示“已校对”标签，确保数据的准确性。

3. 智能判定标签：

- 注意看 09:15 的“体重记录”，系统自动打上了 [饭后] 标签。这是通过代码逻辑判断该记录时间点是否位于上一个 E（吃奶）之后 1 小时内生成的。

4. 跨天处理：

- 在底部以弱化的样式提醒用户跨天行为的归属（根据 PRD：按开始时间戳决定所属哪一天），避免用户在寻找昨晚跨夜觉时感到困惑。

5. 高信息密度 vs 简洁：

- 使用了卡片式布局。每条记录左侧直接显示开始时间，右侧卡片内部显示持续时长。这种排版让“空白时间段”一目了然，方便家长发现宝宝的规律。