package com.appshub.liclash

import android.os.Bundle
import com.appshub.liclash.plugins.AppPlugin
import com.appshub.liclash.plugins.ServicePlugin
import com.appshub.liclash.plugins.TilePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 销毁旧的服务引擎，避免与新的UI引擎冲突
        // 这与原版FlClash的行为保持一致
        CoroutineScope(Dispatchers.Main).launch {
            GlobalState.destroyServiceEngine()
        }
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(AppPlugin())
        flutterEngine.plugins.add(ServicePlugin)
        flutterEngine.plugins.add(TilePlugin())
        GlobalState.flutterEngine = flutterEngine
    }

    override fun onDestroy() {
        // 只清除引擎引用，不要改变VPN运行状态
        // 当Activity被销毁时，VPN服务可能仍在运行
        // VPN状态应该通过实际的服务状态来同步，而不是在这里强制设置
        GlobalState.flutterEngine = null
        super.onDestroy()
    }
}