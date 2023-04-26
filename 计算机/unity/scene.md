## 跳转
假设需要从场景A跳转到场景B，由于场景B场景较大，如果采用同步加载方式，就会在场景A某一帧处卡顿（看上去就像死机了），什么也不能做。所以加载操作一般使用异步。
```c#
using UnityEngine.SceneManagement;


public void Jump()
{
    // 跳转到战斗页面
    StartCoroutine(Battle());
}

IEnumerator Battle()
{
    AsyncOperation op = SceneManager.LoadSceneAsync("your scene name");
    yield return new WaitForEndOfFrame();
    op.allowSceneActivation = true;
}
```

1. AsyncOperation 在你不主动设置AllowSceneActivation = false的情况下，isDown会随着progress的增长（从0增长到1）自动变成true，所以会自动跳转场景；
2. 如果你不想让场景进行自动跳转，你就需要在异步加载时设置allowSceneActivation = false，这会使场景不进行自动跳转，原因是isDown在allowSceneActivation = false 的情况下 永远不会为true，并且此时的aysncOperation.progress也最多可以加载到0.9（90%），当你允许你的场景跳转时（设置allowSceneActivation = true），progress加载最后的10%，直到progress = 1， isDown此时自动变为true，异步加载完成，实现场景跳转。


亦或者增加加载进度条，优化加载体验：比如当前在scene A，想要跳转到Scene B，但是由于scene B较大，加载较慢，我们可以增加一个中间的scene C，即A立即加载C，由C显示进度条，以及异步加载B。scene C的代码样例如下：
```c#
//这个脚本我挂在了我用于显示百分比的Text下
public class LoadAsyncScene : MonoBehaviour {
    //显示进度的文本
    private Text progress;
    //进度条的数值
    private float progressValue;
    //进度条
    private Slider slider;
    public string nextSceneName;
    private AsyncOperation async = null;

    private void Start() {
        progress = GetComponent<Text>();
        slider = FindObjectOfType<Slider>();
        StartCoroutine("LoadScene");
    }
 
    IEnumerator LoadScene() {
        async = SceneManager.LoadSceneAsync(nextSceneName);
        // 不允许自动跳转，因为自动的话，在进度条90%就会开始跳转
        async.allowSceneActivation = false;
        while (!async.isDone) {
            // 显示异步任务的进度，进度大于90%，就认为是100%
            if (async.progress < 0.9f)
                progressValue = async.progress;
            else
                progressValue = 1.0f;
            // 修改进度条数值
            slider.value = progressValue;
            progress.text = (int)(slider.value * 100) + " %";

            // 加载完成，等待用户点击（实际中也可以无需用户点击），然后跳转
            if (progressValue >= 0.9) {
                progress.text = "按任意键继续";
                if (Input.anyKeyDown) {
                    async.allowSceneActivation = true;
                }
            }
            yield return null;
        }
    }
}
```