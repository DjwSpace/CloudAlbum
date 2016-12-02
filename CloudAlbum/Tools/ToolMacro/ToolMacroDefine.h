//
//  ToolMacroDefine.h
//  CloudPhoto
//
//  Created by 芏小川 on 16/11/21.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#ifndef ToolMacroDefine_h
#define ToolMacroDefine_h

//屏幕宽高
#define VIEW_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define VIEW_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//字符串判空
#define IsEmptyString(str) (([str isKindOfClass:[NSNull class]] || str == nil || [str length]<=0)? YES : NO )

#endif /* ToolMacroDefine_h */
