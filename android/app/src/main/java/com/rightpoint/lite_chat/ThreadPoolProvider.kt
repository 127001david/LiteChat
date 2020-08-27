package com.rightpoint.lite_chat

import java.util.concurrent.Executors
import java.util.concurrent.LinkedBlockingDeque
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/13 8:54 AM
 */
object ThreadPoolProvider {
    private val mThreadPool = ThreadPoolExecutor(4, 8, 10,
            TimeUnit.SECONDS, LinkedBlockingDeque(),
            Executors.defaultThreadFactory())

    fun execute(runnable: () -> Unit) {
        mThreadPool.execute(runnable)
    }
}