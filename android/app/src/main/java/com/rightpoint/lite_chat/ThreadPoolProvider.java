package com.rightpoint.lite_chat;

import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/13 8:54 AM 
 */
public class ThreadPoolProvider {
    static final private ThreadPoolExecutor mThreadPool = new ThreadPoolExecutor(4, 8, 10,
            TimeUnit.SECONDS, new LinkedBlockingDeque<Runnable>(),
            Executors.defaultThreadFactory());

    static public void extute(Runnable runnable) {
        mThreadPool.execute(runnable);
    }
}
